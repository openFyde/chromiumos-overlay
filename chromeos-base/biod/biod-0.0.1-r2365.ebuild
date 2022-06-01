# Copyright 2016 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="200d966b5647a49ca460c18763fad1bceb447366"
CROS_WORKON_TREE=("d4469c62dab4018d72e6355d285651f2780df211" "eb3f21801530c0b7c3b385dd4d7606e24aaddaeb" "f96e7f7725f593c25f382779194115af6c785b6d" "5b3f6855a39bb9ec94129a9477b3f5ff4e26e07f" "7226e3910790963c0810793db376ae53c9a32be5" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_USE_VCSID="1"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk biod chromeos-config libec metrics .gn"

PLATFORM_SUBDIR="biod"

inherit cros-fuzzer cros-sanitizers cros-workon cros-unibuild platform udev user

DESCRIPTION="Biometrics Daemon for Chromium OS"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/biod/README.md"

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE="
	factory_branch
	fp_on_power_button
	fpmcu_firmware_bloonchipper
	fpmcu_firmware_dartmonkey
	fpmcu_firmware_nami
	fpmcu_firmware_nocturne
	fuzzer
"

COMMON_DEPEND="
	chromeos-base/chromeos-config-tools:=
	chromeos-base/libec:=
	>=chromeos-base/metrics-0.0.1-r3152:=
	chromeos-base/vboot_reference:=
	sys-apps/flashmap:=
"

# For biod_client_tool. The biod_proxy library will be built on all boards but
# biod_client_tool will be built only on boards with biod.
COMMON_DEPEND+="
	chromeos-base/biod_proxy:=
"

RDEPEND="
	${COMMON_DEPEND}
	sys-apps/flashrom
	!factory_branch? ( virtual/chromeos-firmware-fpmcu )
	"

# Release branch firmware.
# The USE flags below come from USE_EXPAND variables.
# See third_party/chromiumos-overlay/profiles/base/make.defaults.
RDEPEND+="
	!factory_branch? (
		fpmcu_firmware_bloonchipper? ( sys-firmware/chromeos-fpmcu-release-bloonchipper )
		fpmcu_firmware_dartmonkey? ( sys-firmware/chromeos-fpmcu-release-dartmonkey )
		fpmcu_firmware_nami? ( sys-firmware/chromeos-fpmcu-release-nami )
		fpmcu_firmware_nocturne? ( sys-firmware/chromeos-fpmcu-release-nocturne )
	)
"

DEPEND="
	${COMMON_DEPEND}
	chromeos-base/chromeos-ec-headers:=
	chromeos-base/power_manager-client:=
	chromeos-base/system_api:=[fuzzer?]
	dev-libs/openssl:=
"

pkg_setup() {
	enewuser biod
	enewgroup biod
}

src_install() {
	platform_install

	udev_dorules udev/99-biod.rules

	# Set up cryptohome daemon mount store in daemon's mount
	# namespace.
	local daemon_store="/etc/daemon-store/biod"
	dodir "${daemon_store}"
	fperms 0700 "${daemon_store}"
	fowners biod:biod "${daemon_store}"

	local fuzzer_component_id="782045"
	platform_fuzzer_install "${S}/OWNERS" "${OUT}"/biod_storage_fuzzer --comp "${fuzzer_component_id}"

	platform_fuzzer_install "${S}/OWNERS" "${OUT}"/biod_crypto_validation_value_fuzzer --comp "${fuzzer_component_id}"
}

platform_pkg_test() {
	platform test_all
}
