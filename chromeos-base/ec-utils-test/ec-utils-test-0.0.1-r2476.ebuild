# Copyright 2016 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=6
CROS_WORKON_COMMIT="2a7b38e425279ff309eb94a71311d2a1ebfc29ee"
CROS_WORKON_TREE="8ffe2438a25f4a8213fad52ad15cd8ef42b69f3c"
CROS_WORKON_PROJECT="chromiumos/platform/ec"
CROS_WORKON_LOCALNAME="ec"
CROS_WORKON_INCREMENTAL_BUILD=1

inherit cros-workon cros-ec-board

DESCRIPTION="Chrome OS EC Utility Helper"

HOMEPAGE="http://www.chromium.org/"
SRC_URI=""

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE="biod -cr50_onboard"

RDEPEND="chromeos-base/ec-utils"

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
		get_ec_boards

		local target
		for target in "${EC_BOARDS[@]}"; do
			if [[ -f "board/${target}/flash_fp_mcu" ]]; then
				einfo "Installing flash_fp_mcu for ${target}"
				dobin "board/${target}/flash_fp_mcu"
			fi
		done
	fi
}
