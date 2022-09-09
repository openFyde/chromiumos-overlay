# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="6b1df2f3150a0c90dfc3f358f57b470757be2f8e"
CROS_WORKON_TREE=("bfb6ecc4da4dc2d7aafa35ed314e5d2fb8f2f8a6" "c3739ac61ca9366b1b532a4ed75cb2896ec83c11" "96f7bc1ac4d4e9fa35b3565e2cbb5af5b5a1a2a6" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
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
IUSE="fuzzer wilco mesa_reven diagnostics mojo_service_manager"

REQUIRED_USE="
	diagnostics? ( mojo_service_manager )
"

# TODO(204734015): Remove app-arch/zstd:=.
COMMON_DEPEND="
	chromeos-base/chromeos-config-tools:=
	chromeos-base/minijail:=
	chromeos-base/missive:=
	chromeos-base/mojo_service_manager:=
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
	chromeos-base/debugd-client:=
	chromeos-base/tpm_manager-client:=
	chromeos-base/system_api:=[fuzzer?]
	media-sound/adhd:=
	x11-drivers/opengles-headers:=
"

# TODO(crbug/1085169): Replace sys-block/fio dependency with an alternative as
# it is very large. It is currently only a dependency of wilco as it is
# currently the only client.
RDEPEND="
	${COMMON_DEPEND}
	dev-util/stressapptest
	wilco? (
		sys-block/fio
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
	platform_install

	if use wilco; then
		# Install udev rules.
		udev_dorules udev/99-ec_driver_files.rules
	fi

	# Install udev rules.
	udev_dorules udev/99-chown_dmi_dir.rules

	# Install fuzzers.
	local fuzzer_component_id="982097"
	platform_fuzzer_install "${S}"/OWNERS "${OUT}"/fetch_system_info_fuzzer \
		--comp "${fuzzer_component_id}"
}

platform_pkg_test() {
	platform test_all
}
