# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CROS_WORKON_COMMIT=("a07b8addd62474da79a8950525c4e0cfaf3d41a9" "eec6d0a6c3962e71e3b1a7db2dfaa422ec88a15e")
CROS_WORKON_TREE=("6589055d0d41e7fc58d42616ba5075408d810f7d" "47889d430231d6ca7b74b0224681821346bae94f" "0317ae0ee6da82324dfb7e3166f9c7ce5ac42f95" "1d995a5f11b89f06713e6b213ea3f8741ace4008")
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
