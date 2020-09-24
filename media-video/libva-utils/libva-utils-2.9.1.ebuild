# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="Collection of utilities and tests for VA-API"
HOMEPAGE="https://01.org/linuxmedia/vaapi"
SRC_URI="https://github.com/intel/libva-utils/archive/${PV}.tar.gz -> ${P}.tar.gz"
KEYWORDS="*"

LICENSE="MIT"
SLOT="0"
IUSE="test"
RESTRICT="!test? ( test )"

BDEPEND="
	virtual/pkgconfig
"
DEPEND="
	>=x11-libs/libva-2.0.0:=
	>=x11-libs/libdrm-2.4
"
RDEPEND="${DEPEND}"

DOCS=( NEWS )

PATCHES=(
	"${FILESDIR}"/0001-Add-a-flag-to-build-vendor.patch
)

src_prepare() {
	default
	sed -e 's/-Werror//' -i test/Makefile.am || die
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		--disable-x11
		--disable-wayland
		--enable-drm
		"$(use_enable test tests)"
		"$(use_enable test vendor_intel)"
	)
	econf "${myeconfargs[@]}"
}
