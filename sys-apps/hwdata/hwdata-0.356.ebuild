# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Hardware identification and configuration data"
HOMEPAGE="https://github.com/vcrhonek/hwdata"
SRC_URI="https://github.com/vcrhonek/hwdata/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
IUSE="+net +pci +usb"
KEYWORDS="*"

RDEPEND="!<sys-apps/hwids-20150717-r11"

src_configure() {
	# configure is not compatible with econf
	local conf=(
		./configure
		--prefix="${EPREFIX}/usr"
		--libdir="${EPREFIX}/lib"
		--datadir="${EPREFIX}/usr/share"
	)
	elog "${conf[*]}"
	"${conf[@]}" || die
}

src_install() {
	emake DESTDIR="${D}" NAME="misc" install

	if ! use net; then
		rm "${D}"/usr/share/misc/iab.txt "${D}"/usr/share/misc/oui.txt || die
	fi
	if ! use pci; then
		rm "${D}"/usr/share/misc/pci.ids || die
	fi
	if ! use usb; then
		rm "${D}"/usr/share/misc/usb.ids || die
	fi

	# Remove unused files.
	rm -r "${D}"/lib || die
	rm "${D}"/usr/share/misc/pnp.ids || die
}
