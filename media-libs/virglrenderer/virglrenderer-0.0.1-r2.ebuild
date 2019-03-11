# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

CROS_WORKON_COMMIT="0ee5a88a8fa7bac7616894819143022edf27de31"
CROS_WORKON_TREE="dc2eecd0f5e7053810de2678908d3f4ff627f435"
CROS_WORKON_PROJECT="chromiumos/third_party/virglrenderer"

inherit autotools cros-fuzzer cros-sanitizers eutils flag-o-matic toolchain-funcs cros-workon

DESCRIPTION="library used implement a virtual 3D GPU used by qemu"
HOMEPAGE="https://virgil3d.github.io/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="*"
IUSE="fuzzer profiling static-libs test"

RDEPEND="
	>=x11-libs/libdrm-2.4.50
	x11-libs/libX11
	media-libs/libepoxy
	fuzzer? (
		media-libs/mesa
		media-libs/minigbm
	)
"
# We need autoconf-archive for @CODE_COVERAGE_RULES@. #568624
DEPEND="${RDEPEND}
	sys-devel/autoconf-archive
	>=x11-misc/util-macros-1.8
	test? ( >=dev-libs/check-0.9.4 )"

PATCHES=(
	"${FILESDIR}"/${PN}-0.7.0-libdrm.patch
)

src_prepare() {
	default
	[[ -e configure ]] || eautoreconf
}

src_configure() {
	sanitizers-setup-env

	if use profiling; then
		append-flags -fprofile-instr-generate -fcoverage-mapping
		append-ldflags -fprofile-instr-generate -fcoverage-mapping
	fi
	econf \
		$(use_enable static-libs static) \
		$(use_enable test tests) \
		$(use_enable fuzzer)
}

src_install() {
	default

	local f="tests/fuzzer/.libs/virgl_fuzzer"
	fuzzer_install "${FILESDIR}/fuzzer-OWNERS" "${f}"

	find "${ED}"/usr -name 'lib*.la' -delete
}
