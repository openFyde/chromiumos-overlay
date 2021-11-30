# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="exFAT filesystem utilities"
HOMEPAGE="https://github.com/relan/exfat"
SRC_URI="https://github.com/relan/exfat/releases/download/v${PV}/${P}.tar.gz"

# COPYING is GPL-2 but ChangeLog says "Relicensed the project from GPLv3+ to GPLv2+"
LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="*"

PATCHES=(
	"${FILESDIR}"/${PN}-1.3.0-use-open-fd.patch
)

src_install() {
	default
	dosym exfatfsck.8 /usr/share/man/man8/fsck.exfat.8
	dosym mkexfatfs.8 /usr/share/man/man8/mkfs.exfat.8
}
