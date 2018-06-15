# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit autotools eutils

if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="https://anongit.freedesktop.org/git/virglrenderer.git"
	KEYWORDS="~*"
	inherit git-r3
else
	GIT_SHA1="2ec172f4c53bbdd6640b852c8002cd057f6ee108"
	SRC_URI="https://github.com/freedesktop/virglrenderer/archive/${GIT_SHA1}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/${PN}-${GIT_SHA1}"
	KEYWORDS="*"
fi

# Uncomment the following line temporarily to update the manifest when updating
# the pinned version via: ebuild $(equery w virglrenderer) manifest
#RESTRICT=nomirror

DESCRIPTION="library used implement a virtual 3D GPU used by qemu"
HOMEPAGE="https://virgil3d.github.io/"

LICENSE="MIT"
SLOT="0"
IUSE="static-libs test"

RDEPEND=">=x11-libs/libdrm-2.4.50
	media-libs/libepoxy"
# We need autoconf-archive for @CODE_COVERAGE_RULES@. #568624
DEPEND="${RDEPEND}
	sys-devel/autoconf-archive
	>=x11-misc/util-macros-1.8
	test? ( >=dev-libs/check-0.9.4 )"

PATCHES=(
	"${FILESDIR}"/${PN}-0.6.0-libdrm.patch
)

src_prepare() {
	default
	[[ -e configure ]] || eautoreconf
}

src_configure() {
	econf \
		$(use_enable static-libs static) \
		$(use_enable test tests)
}

src_install() {
	default
	find "${ED}"/usr -name 'lib*.la' -delete
}
