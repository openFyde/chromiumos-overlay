# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit cros-sanitizers eutils autotools

DESCRIPTION="Epson Inkjet Printer Driver (ESC/P-R)"
HOMEPAGE="http://download.ebz.epson.net/dsc/search/01/search/?OSC=LX"
SRC_URI="https://download3.ebz.epson.net/dsc/f/03/00/13/43/81/cbdd80826424935cef20d16be8ee5851388977a7/epson-inkjet-printer-escpr-1.7.18-1lsb3.2.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="*"
IUSE=""

DEPEND="net-print/cups"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/1.6.5-warnings.patch"
	"${FILESDIR}/${PN}-1.6.10-search-filter.patch"
	"${FILESDIR}/${PN}-1.7.6-cupsRasterHeader.patch"
)

src_prepare() {
	epatch "${PATCHES[@]}"
	epatch_user
	eautoreconf
}

src_configure() {
	sanitizers-setup-env
	econf --disable-shared

	# Makefile calls ls to generate a file list which is included in Makefile.am
	# Set the collation to C to avoid automake being called automatically
	unset LC_ALL
	export LC_COLLATE=C
}

src_install() {
	emake -C src DESTDIR="${D}" install
}
