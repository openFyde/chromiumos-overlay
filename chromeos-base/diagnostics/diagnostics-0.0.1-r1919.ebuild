# Copyright 2018 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="df94d1ef6df238332542173610bceb70705218d9"
CROS_WORKON_TREE=("6350979dbc8b7aa70c83ad8a03dded778848025d" "258503e66813ac242d8f624f7ceb90743b402de7" "7364a2143c48e5075eed6b89d699e401b0b2d5c6" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_DESTDIR="${S}/platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
# TODO(crbug.com/1044813): Remove chromeos-config once its public headers are fixed.
CROS_WORKON_SUBTREE="common-mk chromeos-config diagnostics .gn"

PLATFORM_SUBDIR="diagnostics"

inherit cros-workon cros-unibuild platform udev user

DESCRIPTION="Device telemetry and diagnostics for Chrome OS"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/diagnostics"

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE="fuzzer wilco mesa_reven diagnostics"

# TODO(204734015): Remove app-arch/zstd:=.
COMMON_DEPEND="
	acct-user/cros_healthd
	acct-group/cros_healthd
	chromeos-base/bootstat:=
	chromeos-base/chromeos-config-tools:=
	chromeos-base/libec:=
	chromeos-base/metrics:=
	chromeos-base/minijail:=
	chromeos-base/missive:=
	chromeos-base/mojo_service_manager:=
	dev-libs/libevdev:=
	dev-libs/protobuf:=
	dev-libs/re2:=
	net-libs/grpc:=
	virtual/libudev:=
	sys-apps/pciutils:=
	virtual/libusb:1=
	virtual/opengles:=
	app-arch/zstd:=
	sys-apps/fwupd:=
"

DEPEND="
	${COMMON_DEPEND}
	chromeos-base/attestation-client:=
	chromeos-base/chromeos-ec-headers:=
	chromeos-base/debugd-client:=
	chromeos-base/libiioservice_ipc:=
	chromeos-base/power_manager-client:=
	chromeos-base/tpm_manager-client:=
	chromeos-base/system_api:=[fuzzer?]
	media-sound/adhd:=
	x11-drivers/opengles-headers:=
"

# TODO(crbug/1085169): Replace sys-block/fio dependency with an alternative as
# it is very large. It is currently only a dependency of wilco as it is
# currently the only client.
# TODO(b/273184171): Remove chromeos-base/ec-utils once we don't rely on ectool.
# TODO(b/271544868): Remove net-wireless/iw once we find alternatives.
RDEPEND="
	${COMMON_DEPEND}
	chromeos-base/ec-utils
	chromeos-base/iioservice
	dev-util/stressapptest
	net-wireless/iw
	wilco? (
		sys-block/fio
		chromeos-base/chromeos-dtc-vm
		chromeos-base/vpd
	)
"

pkg_preinst() {
	enewgroup cros_ec-access
	enewgroup fpdev
	enewuser healthd_ec
	enewgroup healthd_ec
	enewuser healthd_fp
	enewgroup healthd_fp
	enewuser healthd_evdev
	enewgroup healthd_evdev
	enewuser healthd_psr
	enewgroup healthd_psr
	enewgroup mei-access

	if use wilco; then
		enewuser wilco_dtc
		enewgroup wilco_dtc
	fi
}

src_install() {
	platform_src_install

	if use wilco; then
		# Install udev rules.
		udev_dorules udev/99-ec_driver_files.rules
	fi

	# Install udev rules.
	udev_dorules udev/99-chown_dmi_dir.rules
	udev_dorules udev/99-mei_driver_files.rules

	# Install fuzzers.
	local fuzzer_component_id="982097"
	platform_fuzzer_install "${S}"/OWNERS "${OUT}"/fetch_system_info_fuzzer \
		--comp "${fuzzer_component_id}"
}

platform_pkg_test() {
	platform test_all
}
