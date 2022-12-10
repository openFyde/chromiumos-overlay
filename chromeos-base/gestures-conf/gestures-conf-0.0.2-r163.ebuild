# Copyright 2014 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="46cb928fc9edeaeaef1931a0072859e4b6e5f10e"
CROS_WORKON_TREE="114b7ef29c2ca267fea320cc4ea9e4f4f9b80695"
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
