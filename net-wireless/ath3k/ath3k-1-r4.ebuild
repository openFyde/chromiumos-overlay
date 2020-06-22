# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="4"
CROS_WORKON_COMMIT="0c04859d8d41e007399cecd2cb33fe0ccd756ba8"
CROS_WORKON_TREE="50e0e93725a1202cb402f054fa71d7267c3f1107"
CROS_WORKON_PROJECT="chromiumos/third_party/atheros"
CROS_WORKON_LOCALNAME="atheros"
CROS_WORKON_OUTOFTREE_BUILD="1"

inherit cros-workon

DESCRIPTION="Atheros AR3012 firmware"
HOMEPAGE="http://www.atheros.com/"

LICENSE="Atheros"
SLOT="0"
KEYWORDS="*"
IUSE=""

RESTRICT="binchecks"

src_install() {
	insinto /lib/firmware/ar3k
	doins ath3k/files/firmware/ar3k/*.dfu
}
