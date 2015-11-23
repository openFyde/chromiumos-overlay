# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/poppler/poppler-0.33.0.ebuild,v 1.1 2015/05/18 11:31:55 dilfridge Exp $

EAPI=5

inherit cmake-utils toolchain-funcs

if [[ "${PV}" == "9999" ]] ; then
	inherit git-r3
	EGIT_REPO_URI="git://git.freedesktop.org/git/${PN}/${PN}"
	SLOT="0/9999"
else
	SRC_URI="http://poppler.freedesktop.org/${P}.tar.xz"
	KEYWORDS="*"
	SLOT="0/52"   # CHECK THIS WHEN BUMPING!!! SUBSLOT IS libpoppler.so SOVERSION
fi

DESCRIPTION="PDF rendering library based on the xpdf-3.0 code base"
HOMEPAGE="http://poppler.freedesktop.org/"

LICENSE="GPL-2"
IUSE="cairo cjk curl cxx debug doc +introspection +jpeg jpeg2k +lcms png qt4 qt5 tiff +utils"

# No test data provided
RESTRICT="test"

COMMON_DEPEND="
	>=media-libs/fontconfig-2.6.0
	>=media-libs/freetype-2.3.9
	sys-libs/zlib
	cairo? (
		dev-libs/glib:2
		>=x11-libs/cairo-1.10.0
		introspection? ( >=dev-libs/gobject-introspection-1.32.1 )
	)
	curl? ( net-misc/curl )
	jpeg? ( virtual/jpeg:0 )
	jpeg2k? ( media-libs/openjpeg:0 )
	lcms? ( media-libs/lcms:2 )
	png? ( media-libs/libpng:0= )
	qt4? (
		dev-qt/qtcore:4
		dev-qt/qtgui:4
	)
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtxml:5
	)
	tiff? ( media-libs/tiff:0 )
"
DEPEND="${COMMON_DEPEND}
	virtual/pkgconfig
"
RDEPEND="${COMMON_DEPEND}
	cjk? ( >=app-text/poppler-data-0.4.4 )
"

DOCS=(AUTHORS NEWS README README-XPDF TODO)

PATCHES=(
	"${FILESDIR}/${PN}-0.26.0-qt5-dependencies.patch"
	"${FILESDIR}/${PN}-0.28.1-fix-multilib-configuration.patch"
	"${FILESDIR}/${PN}-0.28.1-respect-cflags.patch"
)

src_configure() {
	local mycmakeargs=(
		-DBUILD_GTK_TESTS=OFF
		-DBUILD_QT4_TESTS=OFF
		-DBUILD_QT5_TESTS=OFF
		-DBUILD_CPP_TESTS=OFF
		-DENABLE_SPLASH=ON
		-DENABLE_ZLIB=ON
		-DENABLE_XPDF_HEADERS=ON
		$(cmake-utils_use_enable curl LIBCURL)
		$(cmake-utils_use_enable cxx CPP)
		$(cmake-utils_use_enable utils)
		$(cmake-utils_use_with cairo)
		$(cmake-utils_use_with introspection GObjectIntrospection)
		$(cmake-utils_use_with jpeg)
		$(cmake-utils_use_with png)
		$(cmake-utils_use_with qt4)
		$(cmake-utils_use_find_package qt5 Qt5Core)
		$(cmake-utils_use_with tiff)
	)
	if use jpeg2k; then
		mycmakeargs+=(-DENABLE_LIBOPENJPEG=openjpeg1)
	else
		mycmakeargs+=(-DENABLE_LIBOPENJPEG=)
	fi
	if use lcms; then
		mycmakeargs+=(-DENABLE_CMS=lcms2)
	else
		mycmakeargs+=(-DENABLE_CMS=)
	fi

	# cmake cannot figure out that our cross compilers are based on gcc,
	# which prevents it from setting correct shared library build options.
	# So we need to help it out here.
	mycmakeargs+=(-DCMAKE_C_COMPILER_ID=GNU)

	# cmake looks for freetype using the FindFreetype.cmake module, which
	# does not call pkg-config.  Setting FREETYPE_DIR to /build/$board/usr
	# helps FindFreetype.cmake find the right cross-build dependencies.
	export FREETYPE_DIR="/$($(tc-getPKG_CONFIG) --cflags-only-I freetype2 | cut -d/ -f 2-4)"

	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install

	if use cairo && use doc; then
		# For now install gtk-doc there
		insinto /usr/share/gtk-doc/html/poppler
		# nonfatal, because live version doesn't provide html documentation.
		nonfatal doins -r "${S}"/glib/reference/html/*
	fi
}
