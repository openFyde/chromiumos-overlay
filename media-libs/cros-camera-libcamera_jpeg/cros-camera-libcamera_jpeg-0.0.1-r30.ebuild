# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CROS_WORKON_COMMIT=("b5248daae48335fa8f199c53dcaf71ac3a37f744" "0721e6874fe6fa422dc97c48224ab4c751afa0c8")
CROS_WORKON_TREE=("6589055d0d41e7fc58d42616ba5075408d810f7d" "8f081d337989007d5f71d016dcebaae1b5f5a71a" "311011cf0c6051487ea5ae41982146a78daba303" "32c5802f3fce5f474cfae5f70fb058b1df68675f")
CROS_WORKON_PROJECT=(
	"chromiumos/platform/arc-camera"
	"chromiumos/platform2"
)
CROS_WORKON_LOCALNAME=(
	"../platform/arc-camera"
	"../platform2"
)
CROS_WORKON_DESTDIR=(
	"${S}/platform/arc-camera"
	"${S}/platform2"
)
CROS_WORKON_SUBTREE=(
	"build common include"
	"common-mk"
)
PLATFORM_GYP_FILE="common/libcamera_jpeg.gyp"

inherit cros-camera cros-workon

DESCRIPTION="Chrome OS camera HAL software JPEG compressor util."

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"

RDEPEND="
	!media-libs/arc-camera3-libcamera_jpeg
	virtual/jpeg:0"

DEPEND="${RDEPEND}
	media-libs/libyuv
	virtual/pkgconfig"

src_unpack() {
	cros-camera_src_unpack
}

src_install() {
	dolib.so "${OUT}/lib/libcamera_jpeg.so"

	cros-camera_doheader include/cros-camera/jpeg_compressor.h

	cros-camera_dopc common/libcamera_jpeg.pc.template
}
