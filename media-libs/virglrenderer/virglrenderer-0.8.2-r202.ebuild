# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

CROS_WORKON_COMMIT="b0fc4b7896a095f1c5f5a3363dc57f0b89e0fd4c"
CROS_WORKON_TREE="5f280e895e7f13608632f5efe8c38a71bb588771"
CROS_WORKON_PROJECT="chromiumos/third_party/virglrenderer"
CROS_WORKON_EGIT_BRANCH="master"

# Prevent automatic uprevs of this package since upstream is out of our control.
CROS_WORKON_MANUAL_UPREV="1"

inherit cros-fuzzer cros-sanitizers eutils flag-o-matic meson cros-workon

DESCRIPTION="library used implement a virtual 3D GPU used by qemu"
HOMEPAGE="https://virgil3d.github.io/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="*"
IUSE="debug fuzzer profiling test virtgpu_native_context vulkan"

RDEPEND="
	chromeos-base/percetto
	>=x11-libs/libdrm-2.4.50
	media-libs/libepoxy
	media-libs/minigbm
	fuzzer? (
		virtual/opengles
	)
	vulkan? (
		media-libs/vulkan-loader
	)
"
# We need autoconf-archive for @CODE_COVERAGE_RULES@. #568624
DEPEND="${RDEPEND}
	sys-devel/autoconf-archive
	fuzzer? ( >=dev-libs/check-0.9.4 )
	test? ( >=dev-libs/check-0.9.4 )
	vulkan? ( dev-util/vulkan-headers )
"

PATCHES=(
	"${FILESDIR}"/0001-vrend-disable-GL_EXT_external_object_fd-path-on-GLES.patch
)

src_prepare() {
	default
}

src_configure() {
	sanitizers-setup-env

	# flto flag added under condition due to llvm open issue
	# https://github.com/llvm/llvm-project/issues/57944
	if ! use fuzzer; then
		append-flags -flto
	fi

	if use profiling; then
		append-flags -fprofile-instr-generate -fcoverage-mapping
		append-ldflags -fprofile-instr-generate -fcoverage-mapping
	fi

	emesonargs+=(
		-Dtracing=percetto
		-Dminigbm_allocation="true"
		-Dplatforms="egl"
		-Dcheck-gl-errors="false"
		$(meson_use fuzzer)
		--buildtype $(usex debug debug release)
	)

	if use virtgpu_native_context; then
		emesonargs+=( -Ddrm-msm-experimental="true" )
	fi

	if use vulkan; then
		emesonargs+=(
			-Dvenus-experimental="true"
			-Drender-server="true"
			-Drender-server-worker="process"
		)
	fi

	# virgl_fuzzer is only built with tests.
	if use test || use fuzzer; then
		emesonargs+=( -Dtests="true" )
	fi

	meson_src_configure
}

src_install() {
	meson_src_install

	local fuzzer_component_id="964076"
	fuzzer_install "${FILESDIR}/fuzzer-OWNERS" \
		"${WORKDIR}/${P}-build"/tests/fuzzer/virgl_fuzzer \
		--options "${FILESDIR}/virgl_fuzzer.options" \
		--comp "${fuzzer_component_id}"
	fuzzer_install "${FILESDIR}/fuzzer-OWNERS" \
		"${WORKDIR}/${P}-build"/vtest/vtest_fuzzer \
		--options "${FILESDIR}/vtest_fuzzer.options" \
		--comp "${fuzzer_component_id}"

	find "${ED}"/usr -name 'lib*.la' -delete
}
