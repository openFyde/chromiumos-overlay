# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

AUTOTOOLS_AUTORECONF=yes

EGIT_REPO_URI="git://github.com/anholt/libepoxy.git"

if [[ ${PV} = 9999* ]]; then
	GIT_ECLASS="git-r3"
	KEYWORDS="*"
	SRC_URI=""
else
	KEYWORDS="*"
	SRC_URI="https://github.com/anholt/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
fi

# Uncomment the following line temporarily to update the manifest when updating
# the pinned version via: ebuild $(equery w libepoxy) manifest
#RESTRICT=nomirror

PYTHON_COMPAT=( python{2_7,3_4,3_5} )
PYTHON_REQ_USE='xml(+)'
inherit autotools-multilib ${GIT_ECLASS} python-any-r1

DESCRIPTION="Epoxy is a library for handling OpenGL function pointer management for you"
HOMEPAGE="https://github.com/anholt/libepoxy"


LICENSE="MIT"
SLOT="0"
IUSE="test"

DEPEND="${PYTHON_DEPS}
	x11-drivers/opengles-headers
	x11-misc/util-macros
	x11-libs/libX11[${MULTILIB_USEDEP}]"
RDEPEND="virtual/opengles"

src_unpack() {
	default
	[[ $PV = 9999* ]] && git-r3_src_unpack
}
