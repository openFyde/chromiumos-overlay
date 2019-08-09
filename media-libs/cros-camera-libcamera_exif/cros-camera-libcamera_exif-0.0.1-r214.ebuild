# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CROS_WORKON_COMMIT="f8e07dae2ad8c152a76d7c76e3cbf9cf2471dcfb"
CROS_WORKON_TREE=("dc1506ef7c8cfd2c5ffd1809dac05596ec18773c" "7134e391e4c04513211b250b665951820d5b0bbd" "7404fd91c4f4e75de8311b491a15aaeb3f5ca950" "f415f90174f18e1972056359c7666031f32ecec1" "34ec149bfffef93be14397dd8372e9c1bdbe7bfe")
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_LOCALNAME="../platform2"
CROS_WORKON_SUBTREE=".gn camera/build camera/common camera/include common-mk"
CROS_WORKON_OUTOFTREE_BUILD="1"
CROS_WORKON_INCREMENTAL_BUILD="1"

PLATFORM_SUBDIR="camera/common/libcamera_exif"

inherit cros-camera cros-workon platform

DESCRIPTION="Chrome OS camera HAL exif util."

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"

RDEPEND="
	!media-libs/arc-camera3-libcamera_exif
	media-libs/libexif"

DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_install() {
	dolib.so "${OUT}/lib/libcamera_exif.so"

	cros-camera_doheader ../../include/cros-camera/exif_utils.h

	cros-camera_dopc ../libcamera_exif.pc.template
}
