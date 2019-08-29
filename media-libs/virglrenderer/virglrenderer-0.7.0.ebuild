# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

CROS_WORKON_COMMIT="336f2f19118b751a645f5db756a5e7629a59ec90"
CROS_WORKON_TREE="74b5a78521c657bee30edb9e33cb0ad6d5cbc703"
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
	"${FILESDIR}"/UPSTREAM-vrend-Ignore-prev-shader-stages-in-shader-key-when-p.patch
	"${FILESDIR}"/UPSTREAM-vrend-Unbind-sampler-view-after-creation.patch
	"${FILESDIR}"/UPSTREAM-vrend-Use-view-target-instead-of-texture-target.patch
	"${FILESDIR}"/FROMLIST-vrend-Keep-track-of-GL_FRAMEBUFFER_SRGB-state-and-re.patch
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
