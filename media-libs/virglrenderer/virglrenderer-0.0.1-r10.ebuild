# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

CROS_WORKON_COMMIT="94172afa3f4f94281b1a19b747aa3f3ae7d7aa14"
CROS_WORKON_TREE="7e4ebf62f2ba94a392384ffeb7b83f37a01a6df7"
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
	media-libs/libepoxy
	fuzzer? (
		media-libs/mesa
		media-libs/minigbm
	)
"
# We need autoconf-archive for @CODE_COVERAGE_RULES@. #568624
DEPEND="${RDEPEND}
	sys-devel/autoconf-archive
	test? ( >=dev-libs/check-0.9.4 )"

PATCHES=(
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
		--disable-glx \
		$(use_enable static-libs static) \
		$(use_enable test tests) \
		$(use_enable fuzzer)
}

src_install() {
	default

	fuzzer_install "${FILESDIR}/fuzzer-OWNERS" tests/fuzzer/.libs/virgl_fuzzer \
		--options "${FILESDIR}/virgl_fuzzer.options"
	fuzzer_install "${FILESDIR}/fuzzer-OWNERS" vtest/.libs/vtest_fuzzer \
		--options "${FILESDIR}/vtest_fuzzer.options"

	find "${ED}"/usr -name 'lib*.la' -delete
}
