# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils

SRC_URI="https://github.com/intel/media-driver/archive/intel-media-${PV}.tar.gz"
S="${WORKDIR}/media-driver-intel-media-${PV}"
KEYWORDS="*"
DESCRIPTION="Intel Media Driver for VAAPI (iHD)"
HOMEPAGE="https://github.com/intel/media-driver"

LICENSE="MIT BSD"
SLOT="0"
IUSE="ihd_cmrtlib"

DEPEND=">=media-libs/gmmlib-${PV}
	>=x11-libs/libva-2.8.0
	>=x11-libs/libpciaccess-0.10:=
"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/0001-Disable-IPC-usage.patch
	"${FILESDIR}"/0002-Decoder-VP9-GEN9-Disable-HPR-VP9-mode-switch-to-avoi.patch
	"${FILESDIR}"/0003-ENCODE-change-slice-header-prefix-for-AVC-Vdenc.patch
	"${FILESDIR}"/0004-Disable-IPC-in-media-driver-next.patch
	"${FILESDIR}"/0005-Media-Common-Enable-new-device-config-for-EHL.patch
	"${FILESDIR}"/0006-Encode-VP9-VDEnc-fix-width-and-height-settings-preve.patch
	"${FILESDIR}"/0007-Explicitly-disable-media-compression.patch
)

src_configure() {
	local mycmakeargs=(
		-DMEDIA_RUN_TEST_SUITE=OFF
		-DBUILD_CMRTLIB="$(usex ihd_cmrtlib ON OFF)"
		-DCMAKE_DISABLE_FIND_PACKAGE_X11=TRUE
	)

	cmake-utils_src_configure
}
