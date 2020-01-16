# Copyright 2014 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="7338b6e81106346e14836fe002af53396df08fe4"
CROS_WORKON_TREE=("7010e07aca1a8f5685729ec7fc8a7691a7ae2808" "1ff9a9d292e9eb05697f1234e78c6ae536044c52" "6db4bd6a6ba1fb961e6a4e346d211e122dd8ef45" "ede0d83eb33d420aed3eda5806ccd357881b4bb0" "0edfcc4b0504e72ddb9c9f03864cc8d2e6c939ad" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_USE_VCSID="1"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
# TODO(crbug.com/809389): Avoid directly including headers from other packages.
CROS_WORKON_SUBTREE="common-mk buffet chromeos-config metrics power_manager .gn"

PLATFORM_NATIVE_TEST="yes"
PLATFORM_SUBDIR="power_manager"

inherit cros-workon platform systemd udev user

DESCRIPTION="Power Manager for Chromium OS"
HOMEPAGE="http://dev.chromium.org/chromium-os/packages/power_manager"

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE="-als buffet +cras cros_embedded +display_backlight fuzzer generated_cros_config -has_keyboard_backlight -keyboard_includes_side_buttons keyboard_convertible_no_side_buttons -legacy_power_button -mosys_eventlog +powerknobs systemd +touchpad_wakeup -touchscreen_wakeup unibuild wilco"
REQUIRED_USE="
	?? ( keyboard_includes_side_buttons keyboard_convertible_no_side_buttons )"

COMMON_DEPEND="
	unibuild? (
		!generated_cros_config? ( chromeos-base/chromeos-config )
		generated_cros_config? ( chromeos-base/chromeos-config-bsp:= )
	)
	chromeos-base/chromeos-config-tools:=
	chromeos-base/metrics:=
	dev-libs/libnl:=
	dev-libs/protobuf:=
	cras? ( media-sound/adhd:= )
	virtual/udev"

RDEPEND="${COMMON_DEPEND}
	chromeos-base/ec-utils
	mosys_eventlog? ( sys-apps/mosys )
"

DEPEND="${COMMON_DEPEND}
	chromeos-base/chromeos-ec-headers:=
	chromeos-base/system_api:=[fuzzer?]"

pkg_setup() {
	# Create the 'power' user and group here in pkg_setup as src_install needs
	# them to change the ownership of power manager files.
	enewuser "power"
	enewgroup "power"
	# Ensure that this group exists so that power_manager can access
	# /dev/cros_ec.
	enewgroup "cros_ec-access"
	cros-workon_pkg_setup
}

src_install() {
	# Binaries for production
	dobin "${OUT}"/backlight_tool  # boot-splash, chromeos-boot-alert
	dobin "${OUT}"/dump_power_status  # crosh's battery_test command
	dobin "${OUT}"/powerd
	dobin "${OUT}"/powerd_setuid_helper
	dobin "${OUT}"/power_supply_info  # feedback
	dobin "${OUT}"/set_cellular_transmit_power
	dobin "${OUT}"/set_wifi_transmit_power
	fowners root:power /usr/bin/powerd_setuid_helper
	fperms 4750 /usr/bin/powerd_setuid_helper

	# Binaries for testing and debugging
	dobin "${OUT}"/check_powerd_config
	use amd64 && dobin "${OUT}"/dump_intel_rapl_consumption
	dobin "${OUT}"/inject_powerd_input_event
	dobin "${OUT}"/memory_suspend_test
	dobin "${OUT}"/powerd_dbus_suspend
	dobin "${OUT}"/send_debug_power_status
	dobin "${OUT}"/set_power_policy
	dobin "${OUT}"/suspend_delay_sample

	# Scripts for production
	dobin powerd/powerd_suspend
	dobin tools/cpufreq_config
	dobin tools/print_sysfs_power_supply_data  # feedback
	dobin tools/send_metrics_on_resume

	# Scripts for testing and debugging
	dobin tools/activate_short_dark_resume
	dobin tools/debug_sleep_quickly
	dobin tools/set_short_powerd_timeouts
	dobin tools/suspend_stress_test

	# Preferences
	insinto /usr/share/power_manager
	doins default_prefs/*
	use als && doins optional_prefs/has_ambient_light_sensor
	use cras && doins optional_prefs/use_cras
	use display_backlight || doins optional_prefs/external_display_only
	use has_keyboard_backlight && doins optional_prefs/has_keyboard_backlight
	use legacy_power_button && doins optional_prefs/legacy_power_button
	use mosys_eventlog && doins optional_prefs/mosys_eventlog

	insinto /etc/dbus-1/system.d
	doins dbus/org.chromium.PowerManager.conf

	# udev scripts and rules.
	exeinto "$(get_udevdir)"
	doexe udev/*.sh
	udev_dorules udev/*.rules

	if use powerknobs; then
		udev/gen_autosuspend_rules.py > "${T}"/98-autosuspend.rules || die
		udev_dorules "${T}"/98-autosuspend.rules
		udev_dorules udev/optional/98-powerknobs.rules
		dobin udev/optional/set_blkdev_pm
		dobin udev/optional/allow_sata_min_power
	fi
	if use keyboard_includes_side_buttons; then
		udev_dorules udev/optional/93-powerd-tags-keyboard-side-buttons.rules
	elif use keyboard_convertible_no_side_buttons; then
		udev_dorules udev/optional/93-powerd-tags-keyboard-convertible.rules
	fi

	if ! use touchpad_wakeup; then
		udev_dorules udev/optional/93-powerd-tags-no-touchpad-wakeup.rules
	elif use unibuild; then
		udev_dorules udev/optional/93-powerd-tags-unibuild-touchpad-wakeup.rules
	fi

	if use touchscreen_wakeup; then
		udev_dorules udev/optional/93-powerd-tags-touchscreen-wakeup.rules
	fi

	if use wilco; then
		udev_dorules udev/optional/93-powerd-wilco-ec-files.rules
	fi

	# Init scripts
	if use systemd; then
		systemd_dounit init/systemd/*.service
		systemd_enable_service boot-services.target powerd.service
		systemd_enable_service system-services.target report-power-metrics.service
		systemd_dotmpfilesd init/systemd/powerd_directories.conf
	else
		insinto /etc/init
		doins init/upstart/*.conf
	fi
	exeinto /usr/share/cros/init
	doexe init/shared/powerd-pre-start.sh

	if use buffet; then
		# Buffet command handler definition
		insinto /etc/buffet/commands
		doins powerd/buffet/*.json
	fi

	# Install fuzz targets.
	local fuzzer
	for fuzzer in "${OUT}"/*_fuzzer; do
		platform_fuzzer_install "${S}"/OWNERS "${fuzzer}"
	done
}

platform_pkg_test() {
	local tests=(
		power_manager_daemon_test
		power_manager_policy_test
		power_manager_system_test
		power_manager_util_test
	)

	local test_bin
	for test_bin in "${tests[@]}"; do
		platform_test "run" "${OUT}/${test_bin}"
	done
}
