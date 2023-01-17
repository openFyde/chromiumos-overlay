# Copyright 2023 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT=("5a5e25f719aa4ea1d64f9ec1bec928df38f73fb1" "393343643f9e60b0660930cb64e7eeee3c0ab9d1")
CROS_WORKON_TREE=("29e7cd983d4c3f626ba44777964e0d7478449542" "7126e53c01913b9430bd84ab177d39b44101a3bb")
CROS_WORKON_LOCALNAME=("platform2" "third_party/tpm2")
CROS_WORKON_PROJECT=("chromiumos/platform2" "chromiumos/third_party/tpm2")
CROS_WORKON_SUBTREE=("hwsec-optee-ta" "")
CROS_WORKON_DESTDIR=("${S}/platform2" "${S}/third_party/tpm2")

inherit cros-workon coreboot-sdk

DESCRIPTION="Trusted Application for HWSec for Op-Tee on ARM"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE="coreboot-sdk"

RDEPEND="chromeos-base/optee_client"

DEPEND="
	${RDEPEND}
	sys-firmware/optee_os_tadevkit
"

# Make sure we don't use SDK gcc anymore.
REQUIRED_USE="coreboot-sdk"

src_configure() {
	export OPTEE_DIR="${SYSROOT}/build/share/optee"
	export PLATFORM=mediatek-mt8195
	export CROSS_COMPILE64=${COREBOOT_SDK_PREFIX_arm64}
	export CROSS_COMPILE_core=${COREBOOT_SDK_PREFIX_arm64}
	export TA_DEV_KIT_DIR=${OPTEE_DIR}/export-ta_arm64
	export TA_OUTPUT_DIR="${WORKDIR}/out"

	# CFLAGS/CXXFLAGS/CPPFLAGS/LDFLAGS are set for userland, but those options
	# don't apply properly to firmware so unset them.
	unset CFLAGS CXXFLAGS CPPFLAGS LDFLAGS
}

src_compile() {
	emake -C "${S}/platform2/hwsec-optee-ta"
}

src_install() {
	insinto /lib/optee_armtz
	doins "${WORKDIR}/out/ed800e33-3c58-4cae-a7c0-fd160e35e00d.ta"
}
