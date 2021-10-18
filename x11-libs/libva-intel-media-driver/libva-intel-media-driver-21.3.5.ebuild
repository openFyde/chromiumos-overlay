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

DEPEND=">=media-libs/gmmlib-21.3.1
	>=x11-libs/libva-2.13.0
"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/0001-Disable-IPC-usage.patch
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
