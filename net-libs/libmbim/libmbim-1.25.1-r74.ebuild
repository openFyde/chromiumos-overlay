# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
CROS_WORKON_COMMIT="b70e9fa3b9705e00e410f92d682c8d15bae62420"
CROS_WORKON_TREE="ba7461c4d4fd6ece6cc09ed7636f635f28046dd5"
CROS_WORKON_PROJECT="chromiumos/third_party/libmbim"

inherit autotools cros-sanitizers cros-workon

DESCRIPTION="MBIM modem protocol helper library"
HOMEPAGE="http://cgit.freedesktop.org/libmbim/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="*"
IUSE="-asan doc static-libs"

RDEPEND=">=dev-libs/glib-2.36
	virtual/libgudev"

DEPEND="${RDEPEND}
	doc? ( dev-util/gtk-doc )
	virtual/pkgconfig"

src_prepare() {
	default
	gtkdocize
	eautoreconf
}

src_configure() {
	sanitizers-setup-env

	econf \
		--enable-mbim-username='modem' \
		--enable-compile-warnings=yes \
		$(use_enable static{-libs,}) \
		$(use_enable {,gtk-}doc)
}

src_test() {
	# TODO(benchan): Run unit tests for non-x86 platforms via qemu.
	[[ "${ARCH}" == "x86" || "${ARCH}" == "amd64" ]] && emake check
}

src_install() {
	default
	use static-libs || rm -f "${ED}"/usr/$(get_libdir)/libmbim-glib.la
}
