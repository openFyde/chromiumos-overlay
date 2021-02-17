# Copyright (c) 2013 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5
CROS_WORKON_COMMIT="e4c6efdc3d91bc433a0602e34d9a00f84b793215"
CROS_WORKON_TREE="e00e26f16729d9fa5f6f932c5ddf72586814fc88"
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
	synctest swrast_test v4l2_stateful_decoder v4l2_stateful_encoder \
	udmabuf_create_test

	if use vulkan; then
		dobin vk_glow
	fi
}
