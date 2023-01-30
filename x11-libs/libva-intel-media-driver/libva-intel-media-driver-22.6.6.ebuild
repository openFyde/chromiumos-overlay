# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

SRC_URI="https://github.com/intel/media-driver/archive/intel-media-${PV}.tar.gz"
S="${WORKDIR}/media-driver-intel-media-${PV}"
KEYWORDS="*"
DESCRIPTION="Intel Media Driver for VAAPI (iHD)"
HOMEPAGE="https://github.com/intel/media-driver"

LICENSE="MIT BSD"
SLOT="0"
IUSE="ihd_cmrtlib video_cards_iHD_g8 video_cards_iHD_g9 video_cards_iHD_g11 video_cards_iHD_g12"
REQUIRED_USE="|| ( video_cards_iHD_g8 video_cards_iHD_g9 video_cards_iHD_g11 video_cards_iHD_g12 )"

DEPEND=">=media-libs/gmmlib-22.0.0:=
	>=x11-libs/libva-2.14.0
"
RDEPEND="${DEPEND}"

PATCHES=(
        "${FILESDIR}"/${PN}-21.4.2-Remove-unwanted-CFLAGS.patch
)

src_configure() {
	local mycmakeargs=(
		-DMEDIA_RUN_TEST_SUITE=OFF
		-DBUILD_TYPE=Release
		-DPLATFORM=linux
		-DCMAKE_DISABLE_FIND_PACKAGE_X11=TRUE
		-DBUILD_CMRTLIB=$(usex ihd_cmrtlib ON OFF)

		-DGEN8=$(usex video_cards_iHD_g8 ON OFF)
		-DGEN9=$(usex video_cards_iHD_g9 ON OFF)
		-DGEN10=OFF
		-DGEN11=$(usex video_cards_iHD_g11 ON OFF)
		-DGEN12=$(usex video_cards_iHD_g12 ON OFF)
	)
	local CMAKE_BUILD_TYPE="Release"
	cmake_src_configure
}
