# Copyright 2016 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="4e85dbb7bbac0e7f482a42c94cfb6d0f639da913"
CROS_WORKON_TREE="2afc1d27a5f632b0aefa0e92b600f977387105eb"
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
