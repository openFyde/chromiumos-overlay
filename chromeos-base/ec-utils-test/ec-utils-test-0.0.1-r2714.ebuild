# Copyright 2016 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=6
CROS_WORKON_COMMIT="67114fa836c2c0d201dbb16ae88a6a9b66f1d94b"
CROS_WORKON_TREE="1754e74a517e5b0fb5b649525bbc490f8af4c69d"
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

RDEPEND="chromeos-base/ec-utils
	dev-util/shflags"

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
				insinto /usr/share/flash_fp_mcu
				doins "util/flash_fp_mcu_common.sh"
			fi
		done
	fi
}
