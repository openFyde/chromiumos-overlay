# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="4"
CROS_WORKON_COMMIT="d00613ad2a05d64a64f61cbf7450fd6c0e671434"
CROS_WORKON_TREE="d0a620b1fe7f0f9c0f7b83c8ceebf3cddaeb0760"
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
