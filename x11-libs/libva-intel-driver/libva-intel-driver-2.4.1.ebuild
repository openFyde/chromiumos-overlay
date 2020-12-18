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
	SRC_URI="https://github.com/intel/intel-vaapi-driver/releases/download/${PV}/intel-vaapi-driver-${PV}.tar.bz2"
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

RDEPEND=">=x11-libs/libva-2.4.0
	>=x11-libs/libdrm-2.4.52[video_cards_intel]
	hybrid_codec? ( media-libs/intel-hybrid-driver )"

DEPEND="${RDEPEND}
	virtual/pkgconfig"

DOCS=( AUTHORS NEWS README )
AUTOTOOLS_PRUNE_LIBTOOL_FILES="all"

src_prepare() {
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
