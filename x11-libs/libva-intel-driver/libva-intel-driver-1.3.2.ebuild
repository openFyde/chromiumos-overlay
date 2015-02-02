# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/libva-intel-driver/libva-intel-driver-1.3.0.ebuild,v 1.2 2014/04/04 18:01:07 aballier Exp $

EAPI=5

SCM=""
if [ "${PV%9999}" != "${PV}" ] ; then # Live ebuild
	SCM=git-2
	EGIT_BRANCH=master
	EGIT_REPO_URI="git://anongit.freedesktop.org/git/vaapi/intel-driver"
fi

AUTOTOOLS_AUTORECONF="yes"
inherit autotools-multilib ${SCM}

DESCRIPTION="HW video decode support for Intel integrated graphics"
HOMEPAGE="http://www.freedesktop.org/wiki/Software/vaapi"
if [ "${PV%9999}" != "${PV}" ] ; then # Live ebuild
	SRC_URI=""
	S="${WORKDIR}/${PN}"
else
	SRC_URI="http://www.freedesktop.org/software/vaapi/releases/libva-intel-driver/${P}.tar.bz2"
fi

LICENSE="MIT"
SLOT="0"
if [ "${PV%9999}" = "${PV}" ] ; then
	KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
else
	KEYWORDS=""
fi
IUSE="+drm wayland X"

RDEPEND=">=x11-libs/libva-1.3.0[X?,wayland?,drm?,${MULTILIB_USEDEP}]
	!<x11-libs/libva-1.0.15[video_cards_intel]
	>=x11-libs/libdrm-2.4.45[video_cards_intel,${MULTILIB_USEDEP}]
	wayland? ( media-libs/mesa[egl,${MULTILIB_USEDEP}] >=dev-libs/wayland-1[${MULTILIB_USEDEP}] )"

DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	epatch "${FILESDIR}"/no_explicit_sync_in_va_sync_surface.patch
	epatch "${FILESDIR}"/Avoid-GPU-crash-with-malformed-streams.patch
	epatch "${FILESDIR}"/Encoding-Reinitialize-CBR-bit-rate-control-parameter.patch
	epatch "${FILESDIR}"/remove-fixed-uses-of-intel-gen4asm-tool.patch
	epatch "${FILESDIR}"/check-that-intel-gen4asm-tool-is-actually-present.patch
	epatch "${FILESDIR}"/0001-vebox-silence-compilation-warning.patch
	epatch "${FILESDIR}"/0002-Add-one-callback-function-for-hw_codec_info-to-initi.patch
	epatch "${FILESDIR}"/0003-change-the-attribute-of-hw_codec_info-so-that-it-can.patch
	epatch "${FILESDIR}"/0004-Encoding-Add-one-hook-callback-function-to-detect-en.patch
	epatch "${FILESDIR}"/0005-Libva-PATCH-V3-1-3-Use-the-inline-CPUID-assembly-to-.patch
	epatch "${FILESDIR}"/0006-Libva-PATCH-V3-2-3-Use-the-strncasecmp-instead-of-st.patch
	epatch "${FILESDIR}"/0007-Libva-PATCH-V3-3-3-Check-the-value-returned-by-strst.patch
	epatch "${FILESDIR}"/0008-Compilation-fixes.patch
	epatch "${FILESDIR}"/Disable-encoding-on-SNB-and-non-BYT-IVB.patch
	epatch "${FILESDIR}"/0001-BACKPORT-i965-render-Explicitly-disable-instancing-f.patch
	epatch "${FILESDIR}"/0002-FROMLIST-BDW-disable-SGVS.patch
	epatch "${FILESDIR}"/Disable-upper-bound-check-for-decoding-on-BDW.patch
	eautoreconf
}

DOCS=( AUTHORS NEWS README )

multilib_src_configure() {
	local myeconfargs=(
		$(use_enable drm)
		$(use_enable wayland)
		$(use_enable X x11)
	)
	autotools-utils_src_configure
}
