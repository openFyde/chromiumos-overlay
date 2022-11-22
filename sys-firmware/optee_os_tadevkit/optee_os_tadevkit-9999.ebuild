# Copyright 2022 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_PROJECT="chromiumos/third_party/OP-TEE/optee_os"
CROS_WORKON_LOCALNAME="optee_os"
CROS_WORKON_DESTDIR="${S}"

inherit cros-workon coreboot-sdk

DESCRIPTION="Op-Tee Secure OS TA Dev Kit"
HOMEPAGE="https://www.github.com/OP-TEE/optee_os"

LICENSE="BSD"
KEYWORDS="~*"
IUSE="coreboot-sdk"

# Make sure we don't use SDK gcc anymore.
REQUIRED_USE="coreboot-sdk"

src_configure() {
	export PLATFORM="mediatek-mt8195"
	export CROSS_COMPILE64=${COREBOOT_SDK_PREFIX_arm64}
	export OPTEE_PATH="${S}"
	export O="${WORKDIR}/out"
	export CFG_ARM64_core="y"
	export DEBUG="0"
	export CFG_EARLY_TA="y"

	# CFLAGS/CXXFLAGS/CPPFLAGS/LDFLAGS are set for userland, but those options
	# don't apply properly to firmware so unset them.
	unset CFLAGS CXXFLAGS CPPFLAGS LDFLAGS
}

src_compile() {
	emake ta-targets=ta_arm64 ta_dev_kit
}

src_install() {
	# Install the dev kit used when building TAs (makefiles, header files, etc.).
	insinto /build/share/optee
	doins -r "${WORKDIR}/out/export-ta_arm64"
}
