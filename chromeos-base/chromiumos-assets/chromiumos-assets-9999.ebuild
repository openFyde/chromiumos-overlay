# Copyright 2014 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=4
CROS_WORKON_PROJECT="chromiumos/platform/chromiumos-assets"
CROS_WORKON_LOCALNAME="chromiumos-assets"

inherit cros-workon toolchain-funcs

DESCRIPTION="Chromium OS-specific assets"
HOMEPAGE="http://www.chromium.org/"
SRC_URI=""
LICENSE="BSD"
SLOT="0"
KEYWORDS="~*"
IUSE=""

# Force devs to uninstall assets-split first.
RDEPEND="!chromeos-base/chromeos-assets-split"

DEPEND="${RDEPEND}"

src_install() {
	insinto /usr/share/chromeos-assets/images
	doins -r "${S}"/images/*

	insinto /usr/share/chromeos-assets/images_100_percent
	doins -r "${S}"/images_100_percent/*

	insinto /usr/share/chromeos-assets/images_200_percent
	doins -r "${S}"/images_200_percent/*
}
