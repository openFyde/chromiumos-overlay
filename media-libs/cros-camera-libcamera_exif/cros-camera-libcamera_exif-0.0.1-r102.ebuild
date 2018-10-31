# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CROS_WORKON_COMMIT=("d977dc7b5636cb9825fab97c1534e9900697d05b" "9bb68ba6f735851b6125f697ca5cf0d07411153c")
CROS_WORKON_TREE=("6589055d0d41e7fc58d42616ba5075408d810f7d" "36ed8b8a975ace82a5ff9ff8f0149f856119236e" "f62010221e3eb0566f97bc9fe74a5d47808c8cc4" "190c4cfe4984640ab62273e06456d51a30cfb725")
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
