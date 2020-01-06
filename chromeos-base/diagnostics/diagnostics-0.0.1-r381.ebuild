# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=6

CROS_WORKON_COMMIT="66ff61891172d71837626015dc50fe2e66f3cd5c"
CROS_WORKON_TREE=("81f7fe23bf497aafef6d4128b33582b4422a9ff5" "5e91dcb8b2cc20e99115673a665e7bcb4db60a2a" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
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
IUSE="fuzzer +seccomp wilco"

COMMON_DEPEND="
	dev-libs/protobuf:=
	dev-libs/re2:=
	net-libs/grpc:=
	virtual/libudev:=
"
DEPEND="
	${COMMON_DEPEND}
	chromeos-base/debugd-client
	chromeos-base/system_api[fuzzer?]
"
RDEPEND="
	${COMMON_DEPEND}
	chromeos-base/minijail
	dev-util/stressapptest
	wilco? (
		chromeos-base/chromeos-dtc-vm
		chromeos-base/vpd
	)
"

pkg_preinst() {
	enewgroup cros_ec-access
	enewuser cros_healthd
	enewgroup cros_healthd
	enewuser healthd_ec
	enewgroup healthd_ec

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
		newins "init/wilco_dtc_supportd-seccomp-${ARCH}.policy" \
			wilco_dtc_supportd-seccomp.policy
		newins "init/wilco-dtc-e2fsck-seccomp-${ARCH}.policy" \
			wilco-dtc-e2fsck-seccomp.policy
		newins "init/wilco-dtc-resize2fs-seccomp-${ARCH}.policy" \
			wilco-dtc-resize2fs-seccomp.policy

		# Install D-Bus configuration file.
		insinto /etc/dbus-1/system.d
		doins dbus/org.chromium.WilcoDtcSupportd.conf
		doins dbus/WilcoDtcUpstart.conf

		# Install the init scripts.
		insinto /etc/init
		doins init/wilco_dtc_dispatcher.conf
		doins init/wilco_dtc_supportd.conf
		doins init/wilco_dtc.conf
	fi

	# Install seccomp policy files.
	insinto /usr/share/policy
	newins "init/cros_healthd-seccomp-${ARCH}.policy" \
		cros_healthd-seccomp.policy
	newins "ectool/ectool_i2cread-seccomp-${ARCH}.policy" \
		ectool_i2cread-seccomp.policy

	# Install D-Bus configuration file.
	insinto /etc/dbus-1/system.d
	doins dbus/org.chromium.CrosHealthd.conf

	# Install the init scripts.
	insinto /etc/init
	doins init/cros_healthd.conf

	# Install the diagnostic routine executables.
	exeinto /usr/libexec/diagnostics
	doexe "${OUT}/urandom"
	doexe "${OUT}/smartctl-check"
	# Install the helper executables required by telemetry.
	doexe "${OUT}/cros_healthd_helper"

	# Install udev rules.
	udev_dorules udev/*.rules

	# Install fuzzers.
	platform_fuzzer_install "${S}"/OWNERS "${OUT}"/fetch_block_device_fuzzer
	platform_fuzzer_install "${S}"/OWNERS "${OUT}"/fetch_cached_vpd_fuzzer
}

platform_pkg_test() {
	local tests=(
		cros_healthd_test
		libcommon_test
		libcros_healthd_utils_test
		routine_test
	)
	if use wilco; then
		tests+=(
			libgrpc_async_adapter_test
			wilco_dtc_supportd_test
		)
	fi

	local test_bin
	for test_bin in "${tests[@]}"; do
		platform_test "run" "${OUT}/${test_bin}"
	done
}
