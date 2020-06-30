# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

SCM=""
if [ "${PV%9999}" != "${PV}" ] ; then # Live ebuild
	SCM=git-r3
	EGIT_BRANCH=master
	EGIT_REPO_URI="https://github.com/intel/libva-utils"
fi

AUTOTOOLS_AUTORECONF="yes"
inherit autotools-utils ${SCM} multilib

DESCRIPTION="Collection of utilities and tests for VA-API"
HOMEPAGE="https://01.org/linuxmedia/vaapi"
if [ "${PV%9999}" != "${PV}" ] ; then # Live ebuild
	SRC_URI=""
else
	SRC_URI="https://github.com/intel/libva-utils/archive/${PV}.tar.gz -> ${P}.tar.gz"
fi

LICENSE="MIT"
SLOT="0"
if [ "${PV%9999}" = "${PV}" ] ; then
	KEYWORDS="-* amd64 x86 ~amd64-linux ~x86-linux"
else
	KEYWORDS=""
fi

IUSE="test"

RDEPEND="
	>=x11-libs/libva-2.1.0
	>=x11-libs/libdrm-2.4"

DEPEND="${RDEPEND}
	virtual/pkgconfig"

DOCS=( CONTRIBUTING.md README.md )

src_prepare() {
	epatch "${FILESDIR}"/0001-Add-a-flag-to-build-vendor.patch
	# Remove after https://github.com/intel/libva-utils/pull/185 lands.
	epatch "${FILESDIR}"/0002-Ifdef-va_x11-in-VP-sample-for-usrptr.patch

	sed -e 's/-Werror//' -i test/Makefile.am || die
	autotools-utils_src_prepare
}

src_configure() {
	local myeconfargs=(
		--disable-x11
		--disable-wayland
		--enable-drm
		"$(use_enable test tests)"
		"$(use_enable test vendor_intel)"
	)
	autotools-utils_src_configure
}
