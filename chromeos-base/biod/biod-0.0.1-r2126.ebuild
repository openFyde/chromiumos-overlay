# Copyright 2016 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="269ba720342563c97123ace40e03cce75765e75f"
CROS_WORKON_TREE=("a3d79a5641e6cda7da95a9316f5d29998cc84865" "8687604dfd73a3709bd86453ebd21f0b473634e1" "755d9210be42dad025ff78343c396e51179d8e55" "667180eb5db7eb65a292552b106b32aa5881c9eb" "2920f1f6e0b4bd988fc1e7cb9320d5d0d9bbfddd" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_USE_VCSID="1"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk biod chromeos-config libec metrics .gn"

PLATFORM_SUBDIR="biod"

inherit cros-fuzzer cros-sanitizers cros-workon platform udev user

DESCRIPTION="Biometrics Daemon for Chromium OS"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/biod/README.md"

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE="
	fp_on_power_button
	fpmcu_firmware_bloonchipper
	fpmcu_firmware_dartmonkey
	fpmcu_firmware_nami
	fpmcu_firmware_nocturne
	fuzzer
	generated_cros_config
	unibuild
"

COMMON_DEPEND="
	chromeos-base/chromeos-config-tools:=
	chromeos-base/libec:=
	>=chromeos-base/metrics-0.0.1-r3152:=
	sys-apps/flashmap:=
	unibuild? (
		!generated_cros_config? ( chromeos-base/chromeos-config )
		generated_cros_config? ( chromeos-base/chromeos-config-bsp:= )
	)
"

# For biod_client_tool. The biod_proxy library will be built on all boards but
# biod_client_tool will be built only on boards with biod.
COMMON_DEPEND+="
	chromeos-base/biod_proxy:=
"

RDEPEND="
	${COMMON_DEPEND}
	sys-apps/flashrom
	virtual/chromeos-firmware-fpmcu
	"

# Release branch firmware.
# The USE flags below come from USE_EXPAND variables.
# See third_party/chromiumos-overlay/profiles/base/make.defaults.
RDEPEND+="
	fpmcu_firmware_bloonchipper? ( sys-firmware/chromeos-fpmcu-release-bloonchipper )
	fpmcu_firmware_dartmonkey? ( sys-firmware/chromeos-fpmcu-release-dartmonkey )
	fpmcu_firmware_nami? ( sys-firmware/chromeos-fpmcu-release-nami )
	fpmcu_firmware_nocturne? ( sys-firmware/chromeos-fpmcu-release-nocturne )
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
	dobin "${OUT}"/biod

	dobin "${OUT}"/bio_crypto_init
	dobin "${OUT}"/bio_wash

	dosbin "${OUT}"/bio_fw_updater

	into /usr/local
	dobin "${OUT}"/biod_client_tool

	insinto /usr/share/policy
	local seccomp_src_dir="init/seccomp"

	newins "${seccomp_src_dir}/biod-seccomp-${ARCH}.policy" \
		biod-seccomp.policy

	newins "${seccomp_src_dir}/bio-crypto-init-seccomp-${ARCH}.policy" \
		bio-crypto-init-seccomp.policy

	insinto /etc/init
	doins init/*.conf

	insinto /etc/dbus-1/system.d
	doins dbus/org.chromium.BiometricsDaemon.conf

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
	platform_test "run" "${OUT}/biod_test_runner"
}
