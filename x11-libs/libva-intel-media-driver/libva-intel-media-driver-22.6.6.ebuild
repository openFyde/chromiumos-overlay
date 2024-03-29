# Copyright 1999-2023 Gentoo Authors
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
IUSE="ihd_cmrtlib video_cards_iHD_g8 video_cards_iHD_g9 video_cards_iHD_g11 video_cards_iHD_g12 disable_VP9_dec"
REQUIRED_USE="|| ( video_cards_iHD_g8 video_cards_iHD_g9 video_cards_iHD_g11 video_cards_iHD_g12 )"

DEPEND=">=media-libs/gmmlib-22.0.0:=
	>=x11-libs/libva-2.14.0
"
RDEPEND="${DEPEND}"

PATCHES=(
		"${FILESDIR}"/${PN}-21.4.2-Remove-unwanted-CFLAGS.patch
	"${FILESDIR}"/${PN}-20.4.5_testing_in_src_test.patch

	"${FILESDIR}"/0001-Disable-IPC-usage.patch
	"${FILESDIR}"/0002-change-slice-header-prefix-for-AVC-Vdenc.patch
	"${FILESDIR}"/0003-Disable-Media-Memory-Compression-MMC-on-ADL.patch
	"${FILESDIR}"/0004-Revert-Media-Common-fixed-regression-about-TGL-KBL-j.patch
	"${FILESDIR}"/0005-Revert-Media-Common-Optimization-getimage.patch
	"${FILESDIR}"/0006-Media-Common-VP-fix-object-capture-ffmpeg.patch
	"${FILESDIR}"/0007-CP-Add-stale-protected-gem-context-check.patch
	"${FILESDIR}"/0008-Encode-Fix-surface-lock-segment-fault.patch
	"${FILESDIR}"/0009-Encode-Fix-an-issue-that-GopPicSize-may-be-0.patch
	"${FILESDIR}"/0010-VP9-Encode-Fix-unaligned-height-static-content-encod.patch
)

src_prepare() {
	# Ideally we would like to just define configure setting
	# -DVP9_Decode_Supported=$(usex VP9_disable_dec no yes)
	# but that is seriously broken in upstream intel-media-23.1.
	if use disable_VP9_dec; then
		PATCHES+=( "${FILESDIR}"/0001-Remove-VP9-decode-from-media_interfaces.patch )
	fi
	cmake_src_prepare
}

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
