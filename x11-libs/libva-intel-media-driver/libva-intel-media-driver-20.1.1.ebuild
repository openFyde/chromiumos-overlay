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
IUSE=""

DEPEND=">=media-libs/gmmlib-${PV}
	>=x11-libs/libva-2.7.1
	>=x11-libs/libpciaccess-0.10:=
"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/0001-Encoder-VP8-GEN9-GEN10-GEN11-Ensure-forced_lf_adjust.patch
	"${FILESDIR}"/0002-Disable-IPC-usage.patch
	"${FILESDIR}"/0003-VP-Explicitly-initialize-maxSrcRect-of-VphalRenderer.patch
	"${FILESDIR}"/0004-VP-fix-crash-in-vp8-playback.patch
	"${FILESDIR}"/0005-VP-Fix-memory-corruption.patch
	"${FILESDIR}"/0006-Decoder-VP9-GEN-9-10-11-12-Fix-the-GPU-hang-due-to-w.patch
	"${FILESDIR}"/0007-Decoder-VP9-GEN9-Disable-HPR-VP9-mode-switch-to-avoi.patch
)

src_configure() {
	local mycmakeargs=(
		-DMEDIA_RUN_TEST_SUITE=OFF
		-DBUILD_CMRTLIB=OFF
		-DCMAKE_DISABLE_FIND_PACKAGE_X11=TRUE
	)

	cmake-utils_src_configure
}
