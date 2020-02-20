# Copyright (c) 2013 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5
CROS_WORKON_COMMIT="1ee2843c69efa847c547441e6e1df9a80e51002a"
CROS_WORKON_TREE="24ce7dd6e7b00184839f36706e5333788ea0274c"
CROS_WORKON_PROJECT="chromiumos/platform/drm-tests"

inherit cros-sanitizers cros-workon toolchain-funcs

DESCRIPTION="Chrome OS DRM Tests"

HOMEPAGE="http://www.chromium.org/"
SRC_URI=""

LICENSE="BSD"
SLOT="0"
KEYWORDS="*"
IUSE="vulkan"

RDEPEND="virtual/opengles
	|| ( media-libs/mesa[gbm] media-libs/minigbm )
	media-libs/libsync
	vulkan? (
		media-libs/vulkan-loader
		virtual/vulkan-icd
	)"
DEPEND="${RDEPEND}
	x11-drivers/opengles-headers"

src_configure() {
	sanitizers-setup-env
	cros-workon_src_configure
}

src_compile() {
	tc-export CC
	emake USE_VULKAN="$(usex vulkan 1 0)"
}

src_install() {
	cd build-opt-local || return
	dobin atomictest drm_cursor_test gamma_test linear_bo_test \
	mapped_texture_test mmap_test null_platform_test plane_test \
	synctest swrast_test vgem_test udmabuf_create_test

	if use vulkan; then
		dobin vk_glow
	fi
}
