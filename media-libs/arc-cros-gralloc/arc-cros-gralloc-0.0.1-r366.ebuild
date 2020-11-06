# Copyright 2016 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="7"
CROS_WORKON_COMMIT="0fe561f0e6eb7f6d8a522f00daad91c69ce2344b"
CROS_WORKON_TREE="807223d4b10eccf9ebec057963dfbdd7e60ffad8"
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
		if [[ "${MTK_MINIGBM_PLATFORM}" == "MT8183" ]] ; then
			export MTK_MT8183=1
			append-cppflags -DMTK_MT8183
		fi
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
