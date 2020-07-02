# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
CROS_WORKON_COMMIT="484d781da1764541b69048b870415b5f0b3f37f0"
CROS_WORKON_TREE="0b50a8cbfeaab415f980f5aa16afaa14be71c8b3"
CROS_WORKON_PROJECT="chromiumos/third_party/libqmi"

inherit autotools cros-sanitizers cros-workon

DESCRIPTION="QMI modem protocol helper library"
HOMEPAGE="http://cgit.freedesktop.org/libqmi/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="*"
IUSE="-asan doc mbim qrtr static-libs"

RDEPEND=">=dev-libs/glib-2.36
	mbim? ( >=net-libs/libmbim-1.18.0 )"
DEPEND="${RDEPEND}
	doc? ( dev-util/gtk-doc )
	sys-devel/autoconf-archive
	virtual/pkgconfig"

src_prepare() {
	default
	gtkdocize
	eautoreconf
}

src_configure() {
	sanitizers-setup-env

	econf \
		--enable-qmi-username='modem' \
		--enable-compile-warnings=yes \
		$(use_enable qrtr) \
		$(use_enable mbim mbim-qmux) \
		$(use_enable static{-libs,}) \
		$(use_enable {,gtk-}doc)
}

src_test() {
	# TODO(benchan): Run unit tests for non-x86 platforms via qemu.
	if [[ "${ARCH}" == "x86" || "${ARCH}" == "amd64" ]] ; then
		# This is an ugly hack that happens to work, but should not be copied.
		LD_LIBRARY_PATH="${SYSROOT}/usr/$(get_libdir)" \
		emake check
	fi
}

src_install() {
	default
	use static-libs || rm -f "${ED}"/usr/$(get_libdir)/libqmi-glib.la
}
