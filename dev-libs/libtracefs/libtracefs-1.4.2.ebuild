# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Library to access the Linux tracing tracefs file system"
HOMEPAGE="https://www.trace-cmd.org"
SRC_URI="https://git.kernel.org/pub/scm/libs/libtrace/libtracefs.git/snapshot/${P}.tar.gz"

LICENSE="LGPL-2.1"
MAJOR_VERSION=$(ver_cut 1)
SLOT="0/${MAJOR_VERSION}"
KEYWORDS="*"
IUSE="test"

RDEPEND=""
DEPEND="${RDEPEND}
	dev-libs/libtraceevent:=
	test? ( dev-util/cunit )
"

src_configure() {
	export pkgconfig_dir=/usr/$(get_libdir)/pkgconfig
	export prefix=/usr
}
