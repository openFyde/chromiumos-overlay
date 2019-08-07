# Copyright 2016 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=6
CROS_WORKON_COMMIT="65beadbaafc88a9c034b23fb9edee6bdcecb4f91"
CROS_WORKON_TREE="69e3f7e50213c36a89d2e0ce27a55e642ad12f13"
CROS_WORKON_PROJECT="chromiumos/platform/ec"
CROS_WORKON_LOCALNAME="ec"
CROS_WORKON_INCREMENTAL_BUILD=1

inherit cros-workon

DESCRIPTION="Chrome OS EC Utility Helper"

HOMEPAGE="http://www.chromium.org/"
SRC_URI=""

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE="biod -cr50_onboard"

RDEPEND="chromeos-base/ec-utils
	biod? ( dev-util/shflags )"

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
