# Copyright (c) 2013 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=6
CROS_WORKON_COMMIT="f05c70748a956bee49541970094e2ba7d55b09ab"
CROS_WORKON_TREE="7e6e72ab723b84a986cf42f2977d1253ca9af8a7"
CROS_WORKON_PROJECT="chromiumos/platform/drm-tests"
CROS_WORKON_LOCALNAME="platform/drm-tests"

inherit cros-sanitizers cros-workon toolchain-funcs

DESCRIPTION="Chrome OS DRM Tests"

HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform/drm-tests/"
SRC_URI=""

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE="
	v4lplugin
	vulkan
	"

RDEPEND="virtual/opengles
	|| ( media-libs/mesa[gbm] media-libs/minigbm )
	media-libs/libsync
	v4lplugin? ( media-libs/libv4lplugins )
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
	if use v4lplugin; then
		einfo "- Using libv4l2plugin"
		append-flags "-DUSE_V4LPLUGIN"
	fi
	emake USE_VULKAN="$(usex vulkan 1 0)" USE_V4LPLUGIN="$(usex v4lplugin 1 0)"
}

src_install() {
	cd build-opt-local || return
	dobin atomictest \
		drm_cursor_test \
		dmabuf_test \
		gamma_test \
		linear_bo_test \
		mapped_access_perf_test \
		mapped_texture_test \
		mmap_test \
		null_platform_test \
		plane_test \
		synctest swrast_test \
		v4l2_stateful_decoder \
		v4l2_stateful_encoder \
		udmabuf_create_test

	if use vulkan; then
		dobin vk_glow
	fi
}
