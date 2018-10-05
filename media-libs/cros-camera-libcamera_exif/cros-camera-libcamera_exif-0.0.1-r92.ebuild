# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CROS_WORKON_COMMIT=("b1567e81e96ca22c40c3bd87ed475a7c7ceeed8d" "a1ff2472b257de3d5ec19609ddb374eeaa0a283b")
CROS_WORKON_TREE=("6589055d0d41e7fc58d42616ba5075408d810f7d" "2835984e4f7c26a6c0ad234cf5cd650a4b0b6266" "f62010221e3eb0566f97bc9fe74a5d47808c8cc4" "2cc251457e1e4f18477bcb58f0117ef2d6e98842")
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
PLATFORM_GYP_FILE="common/libcamera_exif.gyp"

inherit cros-camera cros-workon

DESCRIPTION="Chrome OS camera HAL exif util."

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"

RDEPEND="
	!media-libs/arc-camera3-libcamera_exif
	media-libs/libexif"

DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_unpack() {
	cros-camera_src_unpack
}

src_install() {
	dolib.so "${OUT}/lib/libcamera_exif.so"

	cros-camera_doheader include/cros-camera/exif_utils.h

	cros-camera_dopc common/libcamera_exif.pc.template
}
