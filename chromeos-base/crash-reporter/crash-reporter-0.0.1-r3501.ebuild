# Copyright 2014 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="d7d02e3d3be256c2f8a276083494cb73428fa44f"
CROS_WORKON_TREE=("c23e9bd8eaa54cbd599b1a7aca04009fd33af563" "cd226b842609b59e04bbf3185980c56f0ff35309" "b0aff38ab54f32cde7c650fc8b2c76674a018970" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
# TODO(crbug.com/809389): Avoid directly including headers from other packages.
CROS_WORKON_SUBTREE="common-mk crash-reporter metrics .gn"

PLATFORM_SUBDIR="crash-reporter"

inherit cros-arm64 cros-i686 cros-workon platform systemd udev user

DESCRIPTION="Crash reporting service that uploads crash reports with debug information"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/crash-reporter/"

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE="cheets chromeless_tty cros_ec cros_embedded -direncryption kvm_guest systemd fuzzer vm-containers"

COMMON_DEPEND="
	chromeos-base/minijail:=
	chromeos-base/google-breakpad:=[cros_i686?,cros_arm64?]
	>=chromeos-base/metrics-0.0.1-r3152:=
	dev-libs/protobuf:=
	dev-libs/re2:=
	kvm_guest? ( net-libs/grpc:= )
	net-misc/curl:=
	sys-libs/zlib:=
"
RDEPEND="${COMMON_DEPEND}
	chromeos-base/chromeos-ca-certificates
	direncryption? ( sys-apps/keyutils:= )
	cros_ec? ( chromeos-base/ec-utils )
"
DEPEND="
	${COMMON_DEPEND}
	chromeos-base/debugd-client:=
	chromeos-base/session_manager-client:=
	chromeos-base/shill-client:=
	chromeos-base/system_api:=[fuzzer?]
	chromeos-base/vboot_reference:=
	chromeos-base/vm_protos:=
"

src_configure() {
	platform_src_configure
	use cheets && use_i686 && platform_src_configure_i686
	use cheets && use_arm64 && platform_src_configure_arm64
}

src_compile() {
	platform_src_compile
	use cheets && use_i686 && platform_src_compile_i686 "core_collector"
	use cheets && use_arm64 && platform_src_compile_arm64 "core_collector"
}

pkg_setup() {
	# Has to be done in pkg_setup() instead of pkg_preinst() since
	# src_install() will need the crash user and group.
	enewuser "crash"
	enewgroup "crash"
	# A group to manage file permissions for files that crash reporter
	# components need to access.
	enewgroup "crash-access"
	# A group to grant access to the user's crash directory (in /home)
	enewgroup "crash-user-access"
	cros-workon_pkg_setup
}

src_install() {
	into /
	dosbin "${OUT}"/crash_reporter
	if ! use vm-containers; then
		dosbin "${OUT}"/crash_sender
	fi

	insinto /etc/dbus-1/system.d
	doins dbus/org.chromium.AnomalyEventService.conf

	local daemon_store="/etc/daemon-store/crash"
	dodir "${daemon_store}"
	fperms 3770 "${daemon_store}"
	fowners crash:crash-user-access "${daemon_store}"

	into /usr
	use cros_embedded || dobin "${OUT}"/anomaly_detector
	dosbin kernel_log_collector.sh

	if use cheets; then
		dobin "${OUT}"/core_collector
		use_i686 && newbin "$(platform_out_i686)"/core_collector "core_collector32"
		use_arm64 && newbin "$(platform_out_arm64)"/core_collector "core_collector64"
	fi

	if use systemd; then
		systemd_dounit init/crash-reporter.service
		systemd_dounit init/crash-boot-collect.service
		systemd_enable_service multi-user.target crash-reporter.service
		systemd_enable_service multi-user.target crash-boot-collect.service
		if ! use vm-containers; then
			systemd_dounit init/crash-sender.service
			systemd_enable_service multi-user.target crash-sender.service
			systemd_dounit init/crash-sender.timer
			systemd_enable_service timers.target crash-sender.timer
		fi
		if ! use cros_embedded; then
			systemd_dounit init/anomaly-detector.service
			systemd_enable_service multi-user.target anomaly-detector.service
		fi
	else
		insinto /etc/init
		doins init/crash-reporter.conf
		doins init/crash-reporter-early-init.conf
		doins init/crash-boot-collect.conf
		if ! use vm-containers; then
			doins init/crash-sender.conf
		fi
		use cros_embedded || doins init/anomaly-detector.conf
	fi

	insinto /etc
	doins crash_reporter_logs.conf

	udev_dorules 99-crash-reporter.rules

	# Install metrics/OWNERS as the owners file for the fuzzers.
	# The owners files need to have actual email addresses, not
	# an include-link.
	platform_fuzzer_install "${S}"/../metrics/OWNERS \
		"${OUT}"/crash_sender_fuzzer \
		--dict "${S}"/crash_sender_fuzzer.dict

	platform_fuzzer_install "${S}"/../metrics/OWNERS \
		"${OUT}"/chrome_collector_fuzzer \
		--dict "${S}"/chrome_collector_fuzzer.dict

	platform_fuzzer_install "${S}"/../metrics/OWNERS \
		"${OUT}"/anomaly_detector_fuzzer \
		--dict "${S}"/anomaly_detector_fuzzer.dict

	# Install crash_serializer into /usr/local/sbin, which is only present
	# on test images. See:
	# https://chromium.googlesource.com/chromiumos/platform2/+/refs/heads/master/dev-install/README.md#Environments
	into /usr/local
	dosbin "${OUT}"/crash_serializer
}

platform_pkg_test() {
	local gtest_filter_user_tests="-*.RunAsRoot*:"
	local gtest_filter_root_tests="*.RunAsRoot*-"

	platform_test "run" "${OUT}/crash_reporter_test" "0" \
		"${gtest_filter_user_tests}"
	platform_test "run" "${OUT}/crash_reporter_test" "1" \
		"${gtest_filter_root_tests}"
	platform_test "run" "${OUT}/anomaly_detector_test"
	platform_test "run" "${OUT}/anomaly_detector_text_file_reader_test"
	platform_test "run" "${OUT}/anomaly_detector_log_reader_test"
}
