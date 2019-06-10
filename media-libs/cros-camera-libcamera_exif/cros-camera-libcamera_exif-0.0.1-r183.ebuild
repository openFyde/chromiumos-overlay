# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CROS_WORKON_COMMIT="5b37b1d6ebac416a636b277dce5bc8655fd90a44"
CROS_WORKON_TREE=("dc1506ef7c8cfd2c5ffd1809dac05596ec18773c" "c1d6f47d810546f7412d95791a85fb4d35831af3" "47a0a1c0c4f5bdd68b99b1846bfaef7c4c3ba2ad" "fa114ae214350b09a867f8cf8f8465412d5b7d89" "f354d140e04d861ac5457214dd14961f6c512112")
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_LOCALNAME="../platform2"
CROS_WORKON_SUBTREE=".gn camera/build camera/common camera/include common-mk"
CROS_WORKON_OUTOFTREE_BUILD="1"
CROS_WORKON_INCREMENTAL_BUILD="1"

PLATFORM_SUBDIR="camera"
PLATFORM_GYP_FILE="common/libcamera_exif.gyp"

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

	cros-camera_doheader include/cros-camera/exif_utils.h

	cros-camera_dopc common/libcamera_exif.pc.template
}
