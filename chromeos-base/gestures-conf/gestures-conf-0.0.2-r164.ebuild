# Copyright 2014 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="a622f0b252c7de984aea54da016c303a103396cb"
CROS_WORKON_TREE="ad3af553773b7c755453ea53d23a7e2e4c105f5f"
CROS_WORKON_LOCALNAME="platform/xorg-conf"
CROS_WORKON_PROJECT="chromiumos/platform/xorg-conf"
CROS_WORKON_OUTOFTREE_BUILD=1

inherit cros-workon

DESCRIPTION="Gestures library configuration files"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform/xorg-conf/"
SRC_URI=""

LICENSE="BSD-Google"
KEYWORDS="*"

RDEPEND="!chromeos-base/touchpad-linearity"
DEPEND=""

src_install() {
	insinto /etc/gesture

	doins 20-mouse.conf
	doins 40-touchpad-cmt.conf
}
