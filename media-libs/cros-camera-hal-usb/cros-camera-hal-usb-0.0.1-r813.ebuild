# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CROS_WORKON_COMMIT="61919ea82d5120f8e3c527b71f294a45f40920d2"
CROS_WORKON_TREE=("e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb" "c920da127f686c434165b6056b1cd740f228df6b" "f289eeffd560c65fc46e3124e9f98ace1e09d086" "1f84b1b31e34405015846577098ab6a0709832a2" "81e5846bfe5501bfe538f216bd28938088ce8c9e" "146083de4f96983ea33839cc84a9acc89eb908ae" "6e3031590b9a7da2c7bd3d068700d87387129b33" "c23e9bd8eaa54cbd599b1a7aca04009fd33af563")
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_LOCALNAME="../platform2"
# TODO(crbug.com/809389): Avoid directly including headers from other packages.
CROS_WORKON_SUBTREE=".gn camera/build camera/common camera/hal/usb camera/include camera/mojo chromeos-config common-mk"
CROS_WORKON_OUTOFTREE_BUILD="1"
CROS_WORKON_INCREMENTAL_BUILD="1"

PLATFORM_SUBDIR="camera/hal/usb"

inherit cros-camera cros-workon platform

DESCRIPTION="Chrome OS USB camera HAL v3."

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE="usb_camera_monocle"

RDEPEND="
	chromeos-base/cros-camera-android-deps
	chromeos-base/cros-camera-libs
	dev-libs/re2
	usb_camera_monocle? ( media-libs/librealtek-sdk )
	media-libs/libsync
	chromeos-base/chromeos-config-tools"

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
