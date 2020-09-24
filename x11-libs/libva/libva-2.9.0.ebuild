# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit multilib-minimal

DESCRIPTION="Video Acceleration (VA) API for Linux"
HOMEPAGE="https://01.org/linuxmedia/vaapi"
SRC_URI="https://github.com/intel/libva/releases/download/${PV}/${P}.tar.bz2"
KEYWORDS="*"
LICENSE="MIT"
SLOT="0/$(ver_cut 1)"
IUSE="utils"

VIDEO_CARDS="intel amdgpu iHD"
for x in ${VIDEO_CARDS}; do
	IUSE+=" video_cards_${x}"
done

RDEPEND="
	>=x11-libs/libdrm-2.4.46[${MULTILIB_USEDEP}]
"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
"
PDEPEND="
	video_cards_intel? ( !video_cards_iHD? ( >=x11-libs/libva-intel-driver-2.0.0[${MULTILIB_USEDEP}] ) )
	video_cards_iHD? ( ~x11-libs/libva-intel-media-driver-20.3.0[${MULTILIB_USEDEP}] )
	video_cards_amdgpu? ( virtual/opengles[${MULTILIB_USEDEP}] )
	utils? ( media-video/libva-utils )
"

DOCS=( NEWS )

MULTILIB_WRAPPED_HEADERS=(
/usr/include/va/va_backend_glx.h
/usr/include/va/va_x11.h
/usr/include/va/va_dri2.h
/usr/include/va/va_dricommon.h
/usr/include/va/va_glx.h
)

multilib_src_configure() {
	local myeconfargs=(
		--with-drivers-path="${EPREFIX}/usr/$(get_libdir)/va/drivers"
		--enable-drm
		--disable-x11
		--disable-glx
		--disable-wayland
	)
	ECONF_SOURCE="${S}" econf "${myeconfargs[@]}"
}

multilib_src_install_all() {
	find "${ED}" -type f -name "*.la" -delete || die
}
