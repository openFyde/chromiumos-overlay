# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

CROS_WORKON_COMMIT="eca01605f2dd5e1f5e58e19d3cbbff868921bc2b"
CROS_WORKON_TREE="272d12a65116f26db2bc76d5052e25e7158bfcda"
CROS_WORKON_PROJECT="chromiumos/third_party/virglrenderer"

CROS_WORKON_BLACKLIST="1"

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
	media-libs/minigbm
	fuzzer? (
		media-libs/mesa
	)
"
# We need autoconf-archive for @CODE_COVERAGE_RULES@. #568624
DEPEND="${RDEPEND}
	sys-devel/autoconf-archive
	test? ( >=dev-libs/check-0.9.4 )"

PATCHES=(
	"${FILESDIR}"/0001-CHROMIUM-Adjust-plane-parameter.patch
	"${FILESDIR}"/0001-CHROMIUM-Revert-vrend-Always-use-a-texture-view-for-.patch
	"${FILESDIR}"/UPSTREAM-shader-re-interpret-GRID_SIZE-BLOCK_ID-and-THREAD_ID.patch
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
		--enable-gbm-allocation \
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
