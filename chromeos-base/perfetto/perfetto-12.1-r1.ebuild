# Copyright 2021 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

# This ebuild is upreved via PuPR, so disable the normal uprev process for
# cros-workon ebuilds.
CROS_WORKON_COMMIT="3f02be823cef0f54e720c0382ffc4507f48e6e4b"
CROS_WORKON_TREE="23faac9d0737521273423773b45e0b36f876efc6"
CROS_WORKON_MANUAL_UPREV=1
CROS_WORKON_LOCALNAME="aosp/external/perfetto"
CROS_WORKON_PROJECT="platform/external/perfetto"
CROS_WORKON_REPO="${CROS_GIT_AOSP_URL}"

inherit cros-constants cros-workon ninja-utils tmpfiles toolchain-funcs user

DESCRIPTION="An open-source project for performance instrumentation and tracing."
HOMEPAGE="https://perfetto.dev/"

KEYWORDS="*"
IUSE="cros-debug"
LICENSE="Apache-2.0"
SLOT="0"

# protobuf dep is for using protoc at build-time to generate perfetto's headers.
BDEPEND="
	dev-util/gn
	dev-util/ninja
	dev-libs/protobuf
"
BUILD_OUTPUT="${WORKDIR}/out_cros/"

src_configure() {
	tc-export CC CXX AR BUILD_CC BUILD_CXX BUILD_AR
	local target_cpu="${ARCH}"
	# Make the "amd64" -> "x64" conversion for the GN arg |target_cpu|.
	if [[ "${target_cpu}" == "amd64" ]]; then
		target_cpu="x64"
	fi

	# Don't turn on is_debug in building the system tracing service daemon.
	# Running a debug build traced with a release build producer will likely
	# cause crashes.
	local is_debug="false"

	local warn_flags=(
		"-Wno-suggest-destructor-override"
		"-Wno-suggest-override"
	)
	# Specify the linker to be used, this will be invoked by
	# perfetto build as link argument "-fuse-ld=<>" so it needs to be
	# the linker name bfd/gold/lld etc. that clang/gcc understand.
	local linker_name="bfd"
	tc-ld-is-gold && linker_name="gold"
	tc-ld-is-lld && linker_name="lld"

	# Cross-compilation args.
	GN_ARGS="
is_system_compiler=true
ar=\"${BUILD_AR}\"
cc=\"${BUILD_CC}\"
cxx=\"${BUILD_CXX}\"
linker=\"${linker_name}\"
target_ar=\"${AR}\"
target_cc=\"${CC}\"
target_cxx=\"${CXX}\"
target_linker=\"${linker_name}\"
target_cpu=\"${target_cpu}\"
target_triplet=\"${CHOST}\"
extra_target_cflags=\"${CFLAGS} ${warn_flags[*]}\"
extra_target_cxxflags=\"${CXXFLAGS} ${warn_flags[*]}\"
extra_target_ldflags=\"${LDFLAGS}\"
"

	# Extra args to make the targets build.
	GN_ARGS+="
is_debug=${is_debug}
enable_perfetto_stderr_crash_dump=false
enable_perfetto_trace_processor_json=false
monolithic_binaries=true
use_custom_libcxx=false
is_hermetic_clang=false
enable_perfetto_zlib=false
skip_buildtools_check=true
perfetto_use_system_protobuf=true
enable_perfetto_version_gen=false
"
	einfo "GN_ARGS = ${GN_ARGS}"
	gn gen "${BUILD_OUTPUT}" --args="${GN_ARGS}" || die
}

src_compile() {
	eninja -C  "${BUILD_OUTPUT}" traced traced_probes perfetto

	# Check the existence of the sdk/ directory before building the sdk static
	# library, as only the release branches contains the sdk sources to be used.
	if [[ -d "${S}/sdk" ]]; then
		# If not building with cros-debug, the SDK should be built with NDEBUG as
		# well.
		use cros-debug || append-cxxflags -DNDEBUG

		(set -x; $(tc-getCXX) ${CXXFLAGS} -Wall -Werror -c -pthread \
			"${S}/sdk/perfetto.cc" -o sdk/perfetto.o) || die
		(set -x; ${AR} rvsc sdk/libperfetto_sdk.a sdk/perfetto.o) || die
	else
		if [[ ${PV} == 9999 ]]; then
			ewarn "Skip the sdk library as directory perfetto/sdk doesn't exist."
		else
			die "The Perfetto SDK doesn't exist."
		fi
	fi
}

src_install() {
	dobin "${BUILD_OUTPUT}/traced"
	dobin "${BUILD_OUTPUT}/traced_probes"
	dobin "${BUILD_OUTPUT}/perfetto"

	dotmpfiles "${FILESDIR}/tmpfiles.d/traced.conf"

	insinto /etc/init
	doins "${FILESDIR}/init/traced.conf"
	doins "${FILESDIR}/init/traced_probes.conf"

	insinto /usr/share/policy
	newins "${FILESDIR}/seccomp/traced-${ARCH}.policy" traced.policy
	newins "${FILESDIR}/seccomp/traced_probes-${ARCH}.policy" traced_probes.policy

	if [[ -d "${S}/sdk" ]]; then
		insinto /usr/include/perfetto
		# Both source and lib are provided for convenience.
		doins "${S}/sdk/perfetto.cc"
		doins "${S}/sdk/perfetto.h"
		dolib.a "${S}/sdk/libperfetto_sdk.a"
	fi
}

pkg_preinst() {
	enewuser "traced"
	enewgroup "traced"
	enewuser "traced-probes"
	enewgroup "traced-probes"
	enewgroup "traced-producer"
	enewgroup "traced-consumer"
}
