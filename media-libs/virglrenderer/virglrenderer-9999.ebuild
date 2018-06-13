# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit autotools eutils flag-o-matic toolchain-funcs

if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="https://anongit.freedesktop.org/git/virglrenderer.git"
	inherit git-r3
else
	SRC_URI="mirror://gentoo/${P}.tar.xz"
	KEYWORDS="*"
fi

DESCRIPTION="library used implement a virtual 3D GPU used by qemu"
HOMEPAGE="https://virgil3d.github.io/"

LICENSE="MIT"
SLOT="0"
IUSE="asan fuzzer static-libs test"

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
	if use fuzzer; then
		epatch "${FILESDIR}"/${PN}-0.6.0-fuzzer.patch
	fi
	[[ -e configure ]] || eautoreconf
}

src_configure() {
	asan-setup-env
	fuzzer-setup-env

	econf \
		$(use_enable static-libs static) \
		$(use_enable test tests) \
		$(use_enable fuzzer)
}

src_install() {
	default

	if use fuzzer; then
		local f="tests/fuzzer/.libs/virgl_fuzzer"
		insinto /usr/libexec/fuzzers
		exeinto /usr/libexec/fuzzers
		doexe "${f}"
		newins "${FILESDIR}/fuzzer-OWNERS" "${f##*/}.owners"
	fi

	find "${ED}"/usr -name 'lib*.la' -delete
}
