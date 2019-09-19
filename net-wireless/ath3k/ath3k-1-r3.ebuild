# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="4"
CROS_WORKON_COMMIT="97c9ec1e9d4b66a3b8dacf6d9e13540eda4938bd"
CROS_WORKON_TREE="945d48f97429bc3744cc1dd9fde66e5f8f782219"
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
