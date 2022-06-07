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
IUSE="ihd_cmrtlib"

DEPEND=">=media-libs/gmmlib-22.0.1:=
	>=x11-libs/libva-2.14.0
"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-20.2.0_x11_optional.patch
	"${FILESDIR}"/${PN}-21.4.2-Remove-unwanted-CFLAGS.patch
	"${FILESDIR}"/${PN}-20.4.5_testing_in_src_test.patch

	"${FILESDIR}"/0001-Disable-IPC-usage.patch
	"${FILESDIR}"/0002-change-slice-header-prefix-for-AVC-Vdenc.patch
	"${FILESDIR}"/0003-Disable-Media-Memory-Compression-MMC-on-ADL.patch
	"${FILESDIR}"/0004-enable-VP8-encode-for-BXT-and-APL.patch
)

src_configure() {
	local mycmakeargs=(
		-DMEDIA_RUN_TEST_SUITE=OFF
		-DBUILD_TYPE=Release
		-DPLATFORM=linux
		-DBUILD_CMRTLIB="$(usex ihd_cmrtlib ON OFF)"
		-DCMAKE_DISABLE_FIND_PACKAGE_X11=TRUE
	)
	local CMAKE_BUILD_TYPE="Release"
	cmake_src_configure
}
