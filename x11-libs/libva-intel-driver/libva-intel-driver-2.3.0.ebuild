# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

SCM=""
if [ "${PV%9999}" != "${PV}" ] ; then # Live ebuild
	SCM=git-r3
	EGIT_BRANCH=master
	EGIT_REPO_URI="https://github.com/intel/intel-vaapi-driver"
fi

AUTOTOOLS_AUTORECONF="yes"
inherit autotools-multilib ${SCM}

DESCRIPTION="HW video decode support for Intel integrated graphics"
HOMEPAGE="https://github.com/intel/intel-vaapi-driver"
if [ "${PV%9999}" != "${PV}" ] ; then # Live ebuild
	SRC_URI=""
	S="${WORKDIR}/${PN}"
else
	SRC_URI="https://github.com/intel/intel-vaapi-driver/archive/${PV}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/intel-vaapi-driver-${PV}"
fi

LICENSE="MIT"
SLOT="0"
if [ "${PV%9999}" = "${PV}" ] ; then
	KEYWORDS="*"
else
	KEYWORDS=""
fi
IUSE="hybrid_codec"

RDEPEND=">=x11-libs/libva-2.1.0
	>=x11-libs/libdrm-2.4.46[video_cards_intel]
	hybrid_codec? ( media-libs/intel-hybrid-driver )"

DEPEND="${RDEPEND}
	virtual/pkgconfig"

DOCS=( AUTHORS NEWS README )
AUTOTOOLS_PRUNE_LIBTOOL_FILES="all"

src_prepare() {
	epatch "${FILESDIR}"/no_explicit_sync_in_va_sync_surface.patch
	epatch "${FILESDIR}"/Avoid-GPU-crash-with-malformed-streams.patch
	epatch "${FILESDIR}"/set_multisample_state_for_gen6.patch
	epatch "${FILESDIR}"/Disable-VP8-decoder-on-BDW.patch
	epatch "${FILESDIR}"/Revert-VPP-clear-a-surface-using-media-pipeline-on-G.patch
	epatch "${FILESDIR}"/UPSTREAM-dont-reset-the-current-target-buffer-fullness-after-initialization.patch
	epatch "${FILESDIR}"/UPSTREAM-use-the-right-buffer-for-the-2nd-level-batchbuffer.patch
	epatch "${FILESDIR}"/UPSTREAM-update-avc-media-kernel-for-bdw-bsw.patch
	epatch "${FILESDIR}"/UPSTREAM-Make-vaExportSurfaceHandle-work-for-IMC3.patch
	epatch "${FILESDIR}"/encoder-vp8-Ensure-forced_lf_adjustment-update-in-me.patch
	epatch "${FILESDIR}"/gen9_vp9_encoder-Ensure-brc-reset-irrespective-of-th.patch
	epatch "${FILESDIR}"/0001-Remove-blitter-usage-from-driver.patch
	epatch "${FILESDIR}"/gen9_vp9_encoder-Relax-the-compressed-frames-minimum.patch
	epatch "${FILESDIR}"/Handle-the-odd-resolution.patch

	sed -e 's/intel-gen4asm/\0diSaBlEd/g' -i configure.ac || die
	autotools-multilib_src_prepare
}

multilib_src_configure() {
	local myeconfargs=(
		--disable-wayland
		--disable-x11
		"$(use_enable hybrid_codec)"
	)
	autotools-utils_src_configure
}
