# Copyright 1999-2021 Gentoo Authors
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

DEPEND=">=media-libs/gmmlib-22.0.1
	>=x11-libs/libva-2.13.0
"
RDEPEND="${DEPEND}"

PATCHES=(
        "${FILESDIR}"/0001-Disable-IPC-usage.patch
	"${FILESDIR}"/0002-change-slice-header-prefix-for-AVC-Vdenc.patch
	"${FILESDIR}"/0003-Disable-Media-Memory-Compression-MMC-on-ADL.patch
	"${FILESDIR}"/0004-fix-bitwise-or-warning.patch
	"${FILESDIR}"/0005-BACKPORT-Upstream-upstream-ADLN.patch
	"${FILESDIR}"/0006-BACKPORT-Add-support-for-ADL-N-Enable-the-cmake-opti.patch
	"${FILESDIR}"/0007-enable-VP8-encode-for-BXT-and-APL.patch
	"${FILESDIR}"/0008-Revert-Media-Common-fixed-regression-about-TGL-KBL-j.patch
	"${FILESDIR}"/0009-Revert-Media-Common-Optimization-getimage.patch
	"${FILESDIR}"/0010-CHROMIUM-disable-GucSubmission-for-adl.patch
	"${FILESDIR}"/0011-BACKPORT-RPLP-upstream.patch
)

src_configure() {
	local mycmakeargs=(
		-DMEDIA_RUN_TEST_SUITE=OFF
		-DBUILD_TYPE=Release
		-DPLATFORM=linux
		-DBUILD_CMRTLIB="$(usex ihd_cmrtlib ON OFF)"
		-DCMAKE_DISABLE_FIND_PACKAGE_X11=TRUE
	)

	cmake_src_configure
}
