# Copyright (c) 2009 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_RUST_CRATE_NAME="minijail-sys"
CROS_WORKON_BLACKLIST=1
CROS_WORKON_LOCALNAME="aosp/external/minijail"
CROS_WORKON_PROJECT="platform/external/minijail"
CROS_WORKON_REPO="https://android.googlesource.com"

# TODO(crbug.com/689060): Re-enable on ARM.
CROS_COMMON_MK_NATIVE_TEST="yes"

inherit cros-debug cros-rust cros-sanitizers cros-workon cros-common.mk toolchain-funcs multilib

DESCRIPTION="helper binary and library for sandboxing & restricting privs of services"
HOMEPAGE="https://android.googlesource.com/platform/external/minijail"

LICENSE="BSD-Google"
KEYWORDS="~*"
IUSE="asan cros-debug +seccomp test"

COMMON_DEPEND="
	sys-libs/libcap:=
	!<chromeos-base/chromeos-minijail-1"

RDEPEND="${COMMON_DEPEND}"
DEPEND="
	${COMMON_DEPEND}
	>=dev-rust/libc-0.2.44:= <dev-rust/libc-0.3.0
	>=dev-rust/pkg-config-0.3.0:= <dev-rust/pkg-config-0.4.0
	test? (
		dev-cpp/gtest:=
	)
"

src_unpack() {
	# Unpack both the project and dependency source code.
	cros-workon_src_unpack
	cros-rust_src_unpack

	export CROS_RUST_CRATE_VERSION="$(cros-rust_get_crate_version)"
}

src_configure() {
	sanitizers-setup-env
	cros-common.mk_src_configure
	cros-rust_src_configure
	export LIBDIR="/$(get_libdir)"
	export USE_seccomp=$(usex seccomp)
	export ALLOW_DEBUG_LOGGING=$(usex cros-debug)
	export USE_SYSTEM_GTEST=yes
	export DEFAULT_PIVOT_ROOT=/mnt/empty
}

src_compile() {
	cros-common.mk_src_compile all $(usex cros_host parse_seccomp_policy '')
	ecargo_build

	use test && ecargo_test --no-run
}

src_test() {
	cros-common.mk_src_test
	if use x86 || use amd64; then
		ecargo_test
	else
		elog "Skipping rust unit tests on non-x86 platform"
	fi
}

src_install() {
	into /
	dosbin "${OUT}"/minijail0
	dolib.so "${OUT}"/libminijail{,preload}.so
	use cros_host && dobin "${OUT}"/parse_seccomp_policy

	doman minijail0.[15]

	local include_dir="/usr/include/chromeos"

	"${S}"/platform2_preinstall.sh "${PV}" "${include_dir}"
	insinto "/usr/$(get_libdir)/pkgconfig"
	doins libminijail.pc

	insinto "${include_dir}"
	doins libminijail.h
	doins scoped_minijail.h

	cros-rust_publish "${CROS_RUST_CRATE_NAME}" "$(cros-rust_get_crate_version)"
}
