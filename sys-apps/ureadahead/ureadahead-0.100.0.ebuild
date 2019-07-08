# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2
inherit eutils

DESCRIPTION="Ureadahead - Read files in advance during boot"
HOMEPAGE="https://launchpad.net/ureadahead"
SRC_URI="http://launchpad.net/ureadahead/trunk/${PV}/+download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="*"

RDEPEND="
	sys-apps/util-linux
	>=sys-fs/e2fsprogs-1.41
	sys-libs/libnih"

DEPEND="${RDEPEND}
	dev-util/pkgconfig
	sys-devel/gettext"

src_prepare() {
	epatch "${FILESDIR}"/${P}-11.patch   # Downloaded from upstream
	epatch "${FILESDIR}"/${P}-13.patch   # Downloaded from upstream
	epatch "${FILESDIR}"/${P}-container.patch
	epatch "${FILESDIR}"/${P}-detect-rotational.patch
	epatch "${FILESDIR}"/${P}-sysmacros.h
	epatch "${FILESDIR}"/${P}-fileio-overflow.patch # crbug.com/216504
}

src_configure() {
	econf --sbindir=/sbin
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	rm -r "${D}/etc/init"
	keepdir /var/lib/ureadahead

	# install init script
	insinto /etc/init
	doins "${FILESDIR}"/init/*.conf
}
