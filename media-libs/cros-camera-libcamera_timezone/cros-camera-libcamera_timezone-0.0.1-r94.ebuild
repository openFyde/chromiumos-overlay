# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CROS_WORKON_COMMIT=("d1ba6a5b8ae098e49015af02beb1970032bf9c55" "4559bd06c12dca8279cbfcd7c40e5366e703a909")
CROS_WORKON_TREE=("6589055d0d41e7fc58d42616ba5075408d810f7d" "5696cf173b6e7752e93820cc24c4388439edf328" "f62010221e3eb0566f97bc9fe74a5d47808c8cc4" "5d76066514dca6a32e833620a997a659f7fb2fd0")
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
PLATFORM_GYP_FILE="common/libcamera_timezone.gyp"

inherit cros-camera cros-workon

DESCRIPTION="Chrome OS camera HAL Time zone util."

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"

RDEPEND="!media-libs/arc-camera3-libcamera_timezone"

DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_unpack() {
	cros-camera_src_unpack
}

src_install() {
	dolib.so "${OUT}/lib/libcamera_timezone.so"

	cros-camera_doheader include/cros-camera/timezone.h

	cros-camera_dopc common/libcamera_timezone.pc.template
}
