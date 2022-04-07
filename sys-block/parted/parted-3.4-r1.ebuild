# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit verify-sig

DESCRIPTION="Create, destroy, resize, check, copy partitions and file systems"
HOMEPAGE="https://www.gnu.org/software/parted/"
SRC_URI="mirror://gnu/${PN}/${P}.tar.xz
	verify-sig? ( mirror://gnu/${PN}/${P}.tar.xz.sig )"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="*"
IUSE="+debug device-mapper nls readline"

# util-linux for libuuid
RDEPEND="
	>=sys-fs/e2fsprogs-1.27
	sys-apps/util-linux
	device-mapper? ( >=sys-fs/lvm2-2.02.45 )
	readline? (
		>=sys-libs/ncurses-5.7-r7:0=
		>=sys-libs/readline-5.2:0=
	)
"
DEPEND="${RDEPEND}"
BDEPEND="
	nls? ( >=sys-devel/gettext-0.12.1-r2 )
	verify-sig? ( sec-keys/openpgp-keys-bcl )
	virtual/pkgconfig
"

VERIFY_SIG_OPENPGP_KEY_PATH=${BROOT}/usr/share/openpgp-keys/bcl.asc

PATCHES=(
	"${FILESDIR}"/${PN}-3.2-po4a-mandir.patch
	"${FILESDIR}"/${PN}-3.3-atari.patch
	# https://lists.gnu.org/archive/html/bug-parted/2022-02/msg00000.html
	"${FILESDIR}"/${P}-posix-printf.patch
	# Fix a file descriptor leak due to fsync errors.
	# See crbug.com/215843 for details.
	"${FILESDIR}/${PN}-3.1-fix-file-descriptor-leak.patch"
)

src_prepare() {
	default
	touch doc/pt_BR/Makefile.in || die
}

src_configure() {
	local myconf=(
		$(use_enable debug)
		$(use_enable device-mapper)
		$(use_enable nls)
		$(use_with readline)
		--disable-rpath
		--disable-static
	)
	econf "${myconf[@]}"
}

DOCS=(
	AUTHORS BUGS ChangeLog NEWS README THANKS TODO doc/{API,FAT,USER.jp}
)

src_install() {
	default
	find "${ED}" -type f -name '*.la' -delete || die
}
