# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

SCM=""
if [ "${PV%9999}" != "${PV}" ] ; then # Live ebuild
	SCM=git-r3
	EGIT_BRANCH=master
	EGIT_REPO_URI="https://github.com/intel/libva"
fi

AUTOTOOLS_AUTORECONF="yes"
inherit autotools-multilib ${SCM} multilib

DESCRIPTION="Video Acceleration (VA) API for Linux"
HOMEPAGE="https://01.org/linuxmedia/vaapi"
if [ "${PV%9999}" != "${PV}" ] ; then # Live ebuild
	SRC_URI=""
	S="${WORKDIR}/${PN}"
else
	SRC_URI="https://github.com/intel/libva/archive/${PV}.tar.gz -> ${P}.tar.gz"
fi

LICENSE="MIT"
SLOT="1"
if [ "${PV%9999}" = "${PV}" ] ; then
	KEYWORDS="*"
else
	KEYWORDS=""
fi
IUSE="+drm egl opengl vdpau wayland X utils"
REQUIRED_USE="|| ( drm wayland X )"

VIDEO_CARDS="amdgpu fglrx intel i965 nouveau nvidia"
for x in ${VIDEO_CARDS}; do
	IUSE+=" video_cards_${x}"
done

# Chromium: remove versions in X dependencies to accomodate older ones
RDEPEND=">=x11-libs/libdrm-2.4.46
	X? (
		x11-libs/libX11
		x11-libs/libXext
		x11-libs/libXfixes
	)
	egl? ( >=media-libs/mesa-9.1.6[egl] )
	opengl? ( >=virtual/opengl-7.0-r1 )
	wayland? ( >=dev-libs/wayland-1.0.6 )"

DEPEND="${RDEPEND}
	virtual/pkgconfig"

# Chromium: remove video_cards_nouveau to libva-vdpau-driver dependency
# as this library is not present in Chromium OS.
PDEPEND="video_cards_nvidia? ( >=x11-libs/libva-vdpau-driver-0.7.4-r1 )
	vdpau? ( >=x11-libs/libva-vdpau-driver-0.7.4-r1 )
	video_cards_amdgpu? ( >=media-libs/libva-amdgpu-driver-17.2.3-r1 )
	video_cards_fglrx? (
		|| ( >=x11-drivers/ati-drivers-14.12-r3
			>=x11-libs/xvba-video-0.8.0-r1 )
		)
	video_cards_intel? ( x11-libs/libva-intel-driver:${SLOT} )
	"

REQUIRED_USE="|| ( drm wayland X )
		opengl? ( X )"

DOCS=( NEWS )

MULTILIB_WRAPPED_HEADERS=(
/usr/include/va/va_backend_glx.h
/usr/include/va/va_x11.h
/usr/include/va/va_dri2.h
/usr/include/va/va_dricommon.h
/usr/include/va/va_glx.h
)

src_prepare() {
	epatch "${FILESDIR}"/"${PV}"-va_enc_h264-fix-union-struct-typo-to-silence-warning.patch
	# Patch linking information in .pc files
	sed -e 's/-lva/-l:libva.so.1/g' -i ${S}/pkgconfig/libva.pc.in || die
	sed -e 's/\(Requires: libva\)/\11/g' -i ${S}/pkgconfig/libva-*.pc.in || die
	sed -e 's/-lva-\${display}/-l:libva-${display}.so.1/g' -i ${S}/pkgconfig/libva-*.pc.in || die
	sed -e 's/-lva-tpi/-l:libva-tpi.so.1/g' -i ${S}/pkgconfig/libva-tpi.pc.in || die
	autotools-utils_src_prepare
}

multilib_src_configure() {
	local myeconfargs=(
		--with-drivers-path="${EPREFIX}/usr/$(get_libdir)/va${SLOT}/drivers"
		--includedir="${EPREFIX}/usr/include/va${SLOT}"
		$(use_enable opengl glx)
		$(use_enable X x11)
		$(use_enable wayland)
		$(use_enable egl)
		$(use_enable drm)
	)
	autotools-utils_src_configure
}

src_install() {
	autotools-utils_src_install
	# Update headers to they include va files from the correct path
	sed -e 's/#include <va\//#include <va1\/va\//g' -i $(find "${D}/usr/include/va${SLOT}" -name *.h) || die
	# Remove .so files as they conflict with other slots
	rm "${D}/usr/$(get_libdir)/"*.so
	# Rename libva*.pc to libva1*.pc
	pushd "${D}/usr/$(get_libdir)/pkgconfig/"
	for f in libva*.pc; do mv ${f} ${f//libva/libva1}; done || die
	popd
}
