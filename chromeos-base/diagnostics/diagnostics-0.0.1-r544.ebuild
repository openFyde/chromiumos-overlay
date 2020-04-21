# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="f7b89fa04da33adbdc77a3b93992a5f557a899b5"
CROS_WORKON_TREE=("2b7b46ab1083cdcc8b17bd7f5b05ddff336b0559" "a0f22a18a45020d4cb1df0c5e8f24bbd522245be" "f221f4e23d59c0f4bacc51fc4573dbf83379cef3" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_PROJECT="chromiumos/platform2"
# TODO(crbug.com/1044813): Remove chromeos-config once its public headers are fixed.
CROS_WORKON_SUBTREE="common-mk chromeos-config diagnostics .gn"

PLATFORM_SUBDIR="diagnostics"

inherit cros-workon platform udev user

DESCRIPTION="Device telemetry and diagnostics for Chrome OS"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/diagnostics"

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE="fuzzer wilco generated_cros_config unibuild"

COMMON_DEPEND="
	unibuild? (
		!generated_cros_config? ( chromeos-base/chromeos-config:= )
		generated_cros_config? ( chromeos-base/chromeos-config-bsp:= )
	)
	chromeos-base/chromeos-config-tools:=
	dev-libs/protobuf:=
	dev-libs/re2:=
	net-libs/grpc:=
	virtual/libudev:=
"

DEPEND="
	${COMMON_DEPEND}
	chromeos-base/debugd-client:=
	chromeos-base/system_api:=[fuzzer?]
"
RDEPEND="
	${COMMON_DEPEND}
	chromeos-base/minijail
	dev-util/stressapptest
	sys-block/fio
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
	newins "ectool/ectool_pwmgetfanrpm-seccomp-${ARCH}.policy" \
		ectool_pwmgetfanrpm-seccomp.policy

	# Install D-Bus configuration file.
	insinto /etc/dbus-1/system.d
	doins dbus/org.chromium.CrosHealthd.conf

	# Install the init scripts.
	insinto /etc/init
	doins init/cros_healthd.conf

	# Install the diagnostic routine executables.
	exeinto /usr/libexec/diagnostics
	doexe "${OUT}/floating-point-accuracy"
	doexe "${OUT}/prime-search"
	doexe "${OUT}/smartctl-check"
	doexe "${OUT}/urandom"

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
