# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CROS_WORKON_COMMIT="a27c2e84964615fded123086a7d9b139b6e9e1b4"
CROS_WORKON_TREE=("dc1506ef7c8cfd2c5ffd1809dac05596ec18773c" "c1d6f47d810546f7412d95791a85fb4d35831af3" "aea01bf14deec0c334b2c605aacd70616cb717b0" "72afe39ddbec739006799d0868bb23ca72501e46" "2704fc4f555038004e6c9e52db1f60302619e8af" "6f3abf0e1487e52593fe1b4fc780df5844fa9cc1")
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_LOCALNAME="../platform2"
CROS_WORKON_SUBTREE=".gn camera/build camera/common camera/include camera/mojo common-mk"
CROS_WORKON_OUTOFTREE_BUILD="1"
CROS_WORKON_INCREMENTAL_BUILD="1"

PLATFORM_SUBDIR="camera"
PLATFORM_GYP_FILE="common/libcamera_jpeg.gyp"

inherit cros-camera cros-workon platform

DESCRIPTION="Chrome OS camera HAL software JPEG compressor util."

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"

RDEPEND="
	!media-libs/arc-camera3-libcamera_jpeg
	media-libs/cros-camera-libcamera_common
	virtual/jpeg:0"

DEPEND="${RDEPEND}
	chromeos-base/libmojo
	media-libs/cros-camera-libcamera_ipc
	media-libs/libyuv
	virtual/pkgconfig"

src_install() {
	dolib.so "${OUT}/lib/libcamera_jpeg.so"

	cros-camera_doheader include/cros-camera/jpeg_compressor.h

	cros-camera_dopc common/libcamera_jpeg.pc.template
}
