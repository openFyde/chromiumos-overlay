# Copyright 2021 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="ee51e8f6e7d474bf990ba840972a80c6a7d55c6a"
CROS_WORKON_TREE="4f570b6770ab57ec0d70319dafc98cef6a6c6062"
CROS_WORKON_PROJECT="chromiumos/third_party/libqrtr-glib"
CROS_WORKON_EGIT_BRANCH="master"

inherit autotools cros-sanitizers cros-workon

DESCRIPTION="QRTR modem protocol helper library"
# TODO(andrewlassalle): replace the homepage once one is created.
HOMEPAGE="https://gitlab.freedesktop.org/mobile-broadband/libqrtr-glib"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="*"
IUSE="doc static-libs"

RDEPEND=">=dev-libs/glib-2.36:2"
BDEPEND="virtual/pkgconfig"
DEPEND="${RDEPEND}
	doc? ( dev-util/gtk-doc )
	sys-devel/autoconf-archive"

src_prepare() {
	default
	gtkdocize
	eautoreconf
}

src_configure() {
	sanitizers-setup-env

	econf \
		--enable-compile-warnings=yes \
		"$(use_enable static{-libs,})" \
		"$(use_enable {,gtk-}doc)"
}

src_test() {
	# TODO(b/180536539): Run unit tests for non-x86 platforms via qemu.
	if [[ "${ARCH}" == "x86" || "${ARCH}" == "amd64" ]] ; then
		# This is an ugly hack that happens to work, but should not be copied.
		LD_LIBRARY_PATH="${SYSROOT}/usr/$(get_libdir)" \
		emake check
	fi
}

src_install() {
	default
	use static-libs || rm -f "${ED}/usr/$(get_libdir)/libqrtr-glib.la"
}
