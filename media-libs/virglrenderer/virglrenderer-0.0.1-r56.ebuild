# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

CROS_WORKON_COMMIT="c7f7d76b473e76041f0d6cbeed1ecffc31cc3260"
CROS_WORKON_TREE="b648b982fd91a22f93e8e62e3a979285077667a3"
CROS_WORKON_PROJECT="chromiumos/third_party/virglrenderer"

inherit cros-fuzzer cros-sanitizers eutils flag-o-matic meson toolchain-funcs cros-workon

DESCRIPTION="library used implement a virtual 3D GPU used by qemu"
HOMEPAGE="https://virgil3d.github.io/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="*"
IUSE="debug fuzzer profiling test"

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
)

src_prepare() {
	default
}

src_configure() {
	sanitizers-setup-env

	if use profiling; then
		append-flags -fprofile-instr-generate -fcoverage-mapping
		append-ldflags -fprofile-instr-generate -fcoverage-mapping
	fi

	emesonargs+=(
		-Dgbm_allocation="true"
		-Dplatforms="egl"
		-Dtests=$(usex test true false)
		$(meson_use fuzzer)
		--buildtype $(usex debug debug release)
	)

	meson_src_configure
}

src_install() {
	meson_src_install

	fuzzer_install "${FILESDIR}/fuzzer-OWNERS" tests/fuzzer/.libs/virgl_fuzzer \
		--options "${FILESDIR}/virgl_fuzzer.options"
	fuzzer_install "${FILESDIR}/fuzzer-OWNERS" vtest/.libs/vtest_fuzzer \
		--options "${FILESDIR}/vtest_fuzzer.options"

	find "${ED}"/usr -name 'lib*.la' -delete
}
