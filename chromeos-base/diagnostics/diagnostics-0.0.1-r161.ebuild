# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=6

CROS_WORKON_COMMIT="11fcbabac44b7fd8c0adf6d1d665439f220041d2"
CROS_WORKON_TREE=("2a8b5e5d33f20cd70c9e7296e1e2a69a05f38164" "89cc02acdff5bf5dfa25691cfa7caae1e0a21da4" "dc1506ef7c8cfd2c5ffd1809dac05596ec18773c")
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_SUBTREE="common-mk diagnostics .gn"

PLATFORM_SUBDIR="diagnostics"

inherit cros-workon platform udev user

DESCRIPTION="Device telemetry and diagnostics for Chrome OS"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/diagnostics"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE="+seccomp wilco"

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
	enewuser cros_healthd
	enewgroup cros_healthd

	if use wilco; then
		enewuser wilco_dtc
		enewgroup wilco_dtc
	fi
}

src_install() {
	dobin "${OUT}/cros_healthd"
	dobin "${OUT}/diag"
	dobin "${OUT}/telem"

	if use wilco; then
		dobin "${OUT}/wilco_dtc_supportd"

		# Install seccomp policy files.
		insinto /usr/share/policy
		use seccomp && newins "init/wilco_dtc_supportd-seccomp-${ARCH}.policy" \
			wilco_dtc_supportd-seccomp.policy

		# Install D-Bus configuration file.
		insinto /etc/dbus-1/system.d
		doins dbus/org.chromium.Diagnosticsd.conf
		doins dbus/WilcoDtcUpstart.conf

		# Install the init scripts.
		insinto /etc/init
		doins init/wilco_dtc_dispatcher.conf
		doins init/wilco_dtc_supportd.conf
		doins init/wilco_dtc.conf
	fi

	# Install the diagnostic routine executables.
	exeinto /usr/libexec/diagnostics
	doexe "${OUT}/urandom"

	# Install udev rules.
	udev_dorules udev/*.rules
}

platform_pkg_test() {
	local tests=(
		libdiag_test
		libgrpc_async_adapter_test
		libtelem_test
		routine_test
	)
	if use wilco; then
		tests+=( wilco_dtc_supportd_test )
	fi

	local test_bin
	for test_bin in "${tests[@]}"; do
		platform_test "run" "${OUT}/${test_bin}"
	done
}
