# Copyright 2016 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="7"
CROS_WORKON_COMMIT="8e9c241b8522576b7e6cf10aa787b4e57aa19f8d"
CROS_WORKON_TREE="d29f0573b76014f1e6b500413f31e7b5fe469b1c"
CROS_WORKON_PROJECT="chromiumos/platform/minigbm"
CROS_WORKON_LOCALNAME="../platform/minigbm"

inherit multilib-minimal arc-build cros-workon

DESCRIPTION="ChromeOS gralloc implementation"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform/minigbm"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"

VIDEO_CARDS="amdgpu exynos intel marvell mediatek msm rockchip tegra virgl"
IUSE="kernel-3_8 kernel-3_14 kernel-3_18 $(printf 'video_cards_%s ' ${VIDEO_CARDS})"
MINI_GBM_PLATFORMS_USE=( mt8183 mt8192 )
IUSE+=" ${MINI_GBM_PLATFORMS_USE[*]/#/minigbm_platform_}"

RDEPEND="
	x11-libs/arc-libdrm[${MULTILIB_USEDEP}]
"
DEPEND="
	${RDEPEND}
	video_cards_amdgpu? ( virtual/arc-opengles )
"

src_configure() {
	# Use arc-build base class to select the right compiler
	arc-build-select-clang

	# This packages uses -flto with gold, which doesn't support -Os
	# or -Oz. This produces a 76KB .so, so optimizing for size is
	# probably not a big deal.
	cros_optimize_package_for_speed

	BUILD_DIR="$(cros-workon_get_build_dir)"

	append-lfs-flags

	# TODO(gsingh): use pkgconfig
	if use video_cards_intel; then
		export DRV_I915=1
		append-cppflags -DDRV_I915
		if ! (use kernel-3_8 || use kernel-3_14 || use kernel-3_18); then
			append-cppflags -DI915_SCANOUT_Y_TILED
		fi
	fi

	if use video_cards_rockchip; then
		export DRV_ROCKCHIP=1
		append-cppflags -DDRV_ROCKCHIP
	fi

	if use video_cards_mediatek; then
		use minigbm_platform_mt8183 && append-cppflags -DMTK_MT8183
		use minigbm_platform_mt8192 && append-cppflags -DMTK_MT8192
		export DRV_MEDIATEK=1
		append-cppflags -DDRV_MEDIATEK
	fi

	if use video_cards_msm; then
		export DRV_MSM=1
		append-cppflags -DDRV_MSM
	fi

	if use video_cards_amdgpu; then
		export DRV_AMDGPU=1
		append-cppflags -DDRV_AMDGPU -DHAVE_LIBDRM
	fi

	if use video_cards_virgl; then
		export DRV_VIRGL=1
		append-cppflags -DDRV_VIRGL -DVIRTIO_GPU_NEXT
	fi

	multilib-minimal_src_configure
}

multilib_src_compile() {
	filter-flags "-DDRI_DRIVER_DIR=*"
	append-cppflags -DDRI_DRIVER_DIR="/vendor/$(get_libdir)/dri"
	export TARGET_DIR="${BUILD_DIR}/"
	emake -C "${S}/cros_gralloc"
	emake -C "${S}/cros_gralloc/gralloc0/tests/"
}

multilib_src_install() {
	exeinto "${ARC_PREFIX}/vendor/$(get_libdir)/hw/"
	doexe "${BUILD_DIR}"/gralloc.cros.so
	into "/usr/local/"
	newbin "${BUILD_DIR}"/gralloctest "gralloctest_${ABI}"
}
