# Copyright 2016 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="ae6b605620eddb90cee9ecfe75acf2ff3bdb8735"
CROS_WORKON_TREE="dd5311030d1ff100c7652dc354f730d23b2b2af1"
CROS_WORKON_PROJECT="chromiumos/platform/ec"
CROS_WORKON_LOCALNAME="platform/ec"
CROS_WORKON_INCREMENTAL_BUILD=1

inherit cros-workon

DESCRIPTION="Chrome OS EC Utility Helper"

HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform/ec/"
SRC_URI=""

LICENSE="BSD-Google"
SLOT="0/0"
KEYWORDS="*"
IUSE="biod -cr50_onboard"

# flash_fp_mcu depends on stm32mon (ec-devutils)
RDEPEND="
	chromeos-base/ec-utils
	biod? (
		chromeos-base/ec-devutils
		dev-util/shflags
	      )
"

src_compile() {
	tc-export CC

	if use cr50_onboard; then
		emake -C extra/rma_reset
	fi
}

src_install() {
	dobin "util/battery_temp"
	dosbin "util/inject-keys.py"

	if use cr50_onboard; then
		dobin "extra/rma_reset/rma_reset"
	fi

	if use biod; then
		einfo "Installing flash_fp_mcu"
		dobin "util/flash_fp_mcu"
	fi
}
