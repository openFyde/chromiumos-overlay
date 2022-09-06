# Copyright 2016 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="c6dbaabd456e903ee28da39228263915bc1e9021"
CROS_WORKON_TREE="6af6633e440994d698b6b90d2d074e8a9af0399b"
CROS_WORKON_PROJECT="chromiumos/platform/ec"
CROS_WORKON_LOCALNAME="platform/ec"
CROS_WORKON_INCREMENTAL_BUILD=1
PYTHON_COMPAT=( python3_{6..9} pypy3 )

inherit cros-workon python-r1

DESCRIPTION="Chrome OS EC Utility Helper"

HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform/ec/"
SRC_URI=""

LICENSE="BSD-Google"
SLOT="0/0"
KEYWORDS="*"
IUSE="biod -cr50_onboard"

# flash_fp_mcu depends on stm32mon (ec-devutils)
RDEPEND="
	${PYTHON_DEPS}
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
		einfo "Installing flash_fp_mcu and fptool"
		dobin "util/flash_fp_mcu"
		newbin "util/fptool.py" "fptool"
	fi
}
