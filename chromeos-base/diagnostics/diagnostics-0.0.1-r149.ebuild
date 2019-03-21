# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=6

CROS_WORKON_COMMIT="4d28dfb845bf75813e72e6308871322032b0fdf4"
CROS_WORKON_TREE=("13228e56ac75327ed92fe81d6a0ed4f5c11c2a6a" "06c2c69d5b2563712ff45eea32b50a3696ef3532" "dc1506ef7c8cfd2c5ffd1809dac05596ec18773c")
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_SUBTREE="common-mk diagnostics .gn"

PLATFORM_SUBDIR="diagnostics"

inherit cros-workon platform user

DESCRIPTION="Device telemetry and diagnostics for Chrome OS"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/diagnostics"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE="+seccomp"

COMMON_DEPEND="
	chromeos-base/libbrillo:=
	net-libs/grpc:=
	dev-libs/protobuf:=
"
DEPEND="
	${COMMON_DEPEND}
	chromeos-base/system_api
"
RDEPEND="
	${COMMON_DEPEND}
	chromeos-base/minijail
"

pkg_preinst() {
	enewuser wilco_dtc
	enewgroup wilco_dtc
}

src_install() {
	dobin "${OUT}/diag"
	dobin "${OUT}/telem"
	dobin "${OUT}/wilco_dtc"
	dobin "${OUT}/wilco_dtc_supportd"

	# Install seccomp policy files.
	insinto /usr/share/policy
	use seccomp && newins "init/wilco_dtc_supportd-seccomp-${ARCH}.policy" \
		wilco_dtc_supportd-seccomp.policy
	use seccomp && newins "init/wilco_dtc-seccomp-${ARCH}.policy" \
		wilco_dtc-seccomp.policy

	# Install D-Bus configuration file.
	insinto /etc/dbus-1/system.d
	doins dbus/org.chromium.Diagnosticsd.conf

	# Install the init scripts.
	insinto /etc/init
	doins init/wilco_dtc_supportd.conf
	doins init/wilco_dtc.conf

	# Install the diagnostic routine executables.
	exeinto /usr/libexec/diagnostics
	doexe "${OUT}/urandom"
}

platform_pkg_test() {
	local tests=(
		libdiag_test
		libgrpc_async_adapter_test
		libtelem_test
		routine_test
		wilco_dtc_supportd_test
	)

	local test_bin
	for test_bin in "${tests[@]}"; do
		platform_test "run" "${OUT}/${test_bin}"
	done
}
