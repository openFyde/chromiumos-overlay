# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CROS_WORKON_COMMIT=("13ad023359e7620a59214560d601c828480c7a78" "91d98a32d80587f401260784a44ee6ba884708ee")
CROS_WORKON_TREE=("6589055d0d41e7fc58d42616ba5075408d810f7d" "840a69ce8adca1d1d9a6fe325803a41117284c00" "f62010221e3eb0566f97bc9fe74a5d47808c8cc4" "62e34ac946e6d1a95cc072d886d6a7087bb6c820" "7bcd83907690430e66b5a71e2dc849fa4b3e41b0")
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
