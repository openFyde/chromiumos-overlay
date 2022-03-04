# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CROS_WORKON_COMMIT="bd127f360ef6e9cf085a55ae15ed8c08dc8d507a"
CROS_WORKON_TREE=("e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb" "e5bab9aeb635f426a5f77597edb46ad386ad0f7c" "a4c500ab9b3c0bc4232aa527a6cbd18f786338a4" "cfa34661bfaee28c42a96a4571cbd091686716bb" "080361d5d45e74e7927e56bab774531748d1a569" "17c0af603db6e69e7d5b07fe21738237ebe29f3f" "6aa4b259533027a10db1d4f89ed4cf9fbc0b65a2")
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_LOCALNAME="../platform2"
# TODO(crbug.com/809389): Avoid directly including headers from other packages.
CROS_WORKON_SUBTREE=".gn camera/build camera/common camera/hal/usb camera/include camera/mojo common-mk"
CROS_WORKON_OUTOFTREE_BUILD="1"
CROS_WORKON_INCREMENTAL_BUILD="1"

PLATFORM_SUBDIR="camera/hal/usb"

inherit cros-camera cros-workon platform

DESCRIPTION="Chrome OS USB camera HAL v3."

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"

RDEPEND="
	chromeos-base/cros-camera-android-deps
	chromeos-base/cros-camera-libs
	dev-libs/re2
	media-libs/libsync"

DEPEND="${RDEPEND}
	media-libs/libyuv
	virtual/pkgconfig"

src_install() {
	platform_src_install
	cros-camera_dohal "${OUT}/lib/libcamera_hal.so" usb.so
}

platform_pkg_test() {
	local tests=(
		image_processor_test
	)
	local test_bin
	for test_bin in "${tests[@]}"; do
		platform_test run "${OUT}/${test_bin}"
	done
}
