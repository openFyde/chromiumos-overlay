# Copyright (c) 2013 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5
CROS_WORKON_COMMIT="7d0e841838050b721dbbdb35ec063244e26d45a6"
CROS_WORKON_TREE="3cf02be81fe6bfb4ae551bcf397f228661042ce2"
CROS_WORKON_PROJECT="chromiumos/platform/drm-tests"

inherit cros-sanitizers cros-workon toolchain-funcs

DESCRIPTION="Chrome OS DRM Tests"

HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform/drm-tests/"
SRC_URI=""

LICENSE="BSD-Google"
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
	default
}

src_compile() {
	tc-export CC
	emake USE_VULKAN="$(usex vulkan 1 0)"
}

src_install() {
	cd build-opt-local || return
	dobin atomictest drm_cursor_test dmabuf_test gamma_test linear_bo_test \
	mapped_texture_test mmap_test null_platform_test plane_test \
	synctest swrast_test v4l2_stateful_encoder udmabuf_create_test

	if use vulkan; then
		dobin vk_glow
	fi
}
