# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=6

CROS_WORKON_COMMIT="a20576eab9cb64f7c6d1224ec491be1969e81055"
CROS_WORKON_TREE=("0ffb93295fdf908289258df9afe6cb5003efa903" "84f84e5f1c5ab19d13679c5783a97c958537234c" "dc1506ef7c8cfd2c5ffd1809dac05596ec18773c")
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
}

platform_pkg_test() {
	local tests=(
		libdiag_test
		libgrpc_async_adapter_test
		libtelem_test
		wilco_dtc_supportd_test
	)

	local test_bin
	for test_bin in "${tests[@]}"; do
		platform_test "run" "${OUT}/${test_bin}"
	done
}
