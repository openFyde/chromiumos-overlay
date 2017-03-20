# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit udev eutils

DESCRIPTION="Hardware (PCI, USB, OUI, IAB) IDs databases"
HOMEPAGE="https://github.com/gentoo/hwids"
if [[ ${PV} == "99999999" ]]; then
	EGIT_REPO_URI="${HOMEPAGE}.git"
	inherit git-2
else
	SRC_URI="${HOMEPAGE}/archive/${P}.tar.gz"
	KEYWORDS="*"
fi

LICENSE="|| ( GPL-2 BSD ) public-domain"
SLOT="0"
IUSE="+net +pci +udev +usb +hwids-lite"

DEPEND="udev? (
	dev-lang/perl
	>=virtual/udev-206
)"
[[ ${PV} == "99999999" ]] && DEPEND+=" udev? ( net-misc/curl )"
RDEPEND="!<sys-apps/pciutils-3.1.9-r2
	!<sys-apps/usbutils-005-r1"

S=${WORKDIR}/hwids-${P}

src_prepare() {
	[[ ${PV} == "99999999" ]] && emake fetch

	sed -i -e '/udevadm hwdb/d' Makefile || die

	# Filter out key mapping entries for AT keyboards in order to avoid
	# potential conflicts with the key mappings expected by Chrome OS for
	# the internal keyboard of a Chromebook.
	sed -i -e '/^evdev:atkbd:/,/^\s*$/ { /^\s*$/!s/^/#/ }' \
		udev/60-keyboard.hwdb || die

	# Create a rules file compatible with older udev.
	sed -e 's/evdev:name/keyboard:name/' \
		-e 's/evdev:atkbd:dmi/keyboard:dmi/' \
		-e 's/evdev:input:b\([^v]*\)v\([^p]*\)p\([^e]*\)\(e.*\)\?/keyboard:usb:v\2p\3/' \
		-e 's/keyboard:usb:v046DpC52D\*/keyboard:usb:v046DpC52Dd*dc*dsc*dp*ic*isc*ip*in00*/' \
		-e 's/keyboard:usb:v0458p0708\*/keyboard:usb:v0458p0708d*dc*dsc*dp*ic*isc*ip*in01*/' \
		udev/60-keyboard.hwdb > udev/61-oldkeyboard.hwdb || die
}

_emake() {
	emake \
		NET=$(usex net) \
		PCI=$(usex pci) \
		UDEV=$(usex udev) \
		USB=$(usex usb) \
		"$@"
}

src_compile() {
	_emake
}

src_install() {
	_emake install \
		DOCDIR="${EPREFIX}/usr/share/doc/${PF}" \
		MISCDIR="${EPREFIX}/usr/share/misc" \
		HWDBDIR="${EPREFIX}$(get_udevdir)/hwdb.d" \
		DESTDIR="${D}"

	if use hwids-lite; then
		cd "${D}/$(get_udevdir)/hwdb.d" || die
		rm 20-OUI.hwdb 20-pci-vendor-model.hwdb 20-usb-vendor-model.hwdb || die
	fi
}

pkg_postinst() {
	if use udev; then
		udevadm hwdb --update --root="${ROOT%/}"
		# http://cgit.freedesktop.org/systemd/systemd/commit/?id=1fab57c209035f7e66198343074e9cee06718bda
		[ "${ROOT:-/}" = "/" ] && udevadm control --reload
	fi
}
