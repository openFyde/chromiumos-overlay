# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="Mount archives using libarchive and FUSE"
HOMEPAGE="https://www.cybernoia.de/software/archivemount.html https://github.com/cybernoid/archivemount"
SRC_URI="https://www.cybernoia.de/software/archivemount/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="*"

RDEPEND="
	app-arch/libarchive:=
	sys-fs/fuse:0"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}/archivemount-0.8.12-dev-fd.patch"
	"${FILESDIR}/archivemount-0.8.12-raw-pathname.patch"
)

src_prepare() {
	default

	# https://bugs.gentoo.org/725998
	sed -i -e 's/CFLAGS=//g' configure.ac || die
	eautoreconf
}
