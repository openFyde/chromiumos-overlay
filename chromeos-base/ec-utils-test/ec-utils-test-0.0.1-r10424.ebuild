# Copyright 2016 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="138e9f8649258cbcade1b1871416d332ac1fa756"
CROS_WORKON_TREE="7b254bebd76d1d68a4fe8a182d2e3f18ff5d654d"
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
