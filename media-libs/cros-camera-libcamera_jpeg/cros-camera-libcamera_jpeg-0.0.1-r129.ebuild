# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CROS_WORKON_COMMIT=("3fe59eefa93489eedeb6c1bc330a5cd1e9b30082" "8e636865b877bbb848b56a43d3b1263bf330a16d")
CROS_WORKON_TREE=("6589055d0d41e7fc58d42616ba5075408d810f7d" "894c45616b0ead5384d53a0d35d09e62e1be95a9" "72afe39ddbec739006799d0868bb23ca72501e46" "2704fc4f555038004e6c9e52db1f60302619e8af" "6cbd9c184c53df44a2031eda68e398d232e73a6e")
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
	"build common include mojo"
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
	media-libs/cros-camera-libcamera_common
	virtual/jpeg:0"

DEPEND="${RDEPEND}
	chromeos-base/libmojo
	media-libs/cros-camera-libcamera_ipc
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
