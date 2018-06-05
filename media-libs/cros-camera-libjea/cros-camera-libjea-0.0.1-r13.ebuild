# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CROS_WORKON_COMMIT=("ea7960c607797fcb8509cc9de3e57107aca1a000" "8698d230cac000601a9a8c3cf66c5f4dc541740d")
CROS_WORKON_TREE=("6589055d0d41e7fc58d42616ba5075408d810f7d" "2dc3df42ca2b47bc7af71581b7eb45accac0e205" "311011cf0c6051487ea5ae41982146a78daba303" "8f3859492d0228b565f17f02fe138f81617c6415" "6dd24c3358b82474c558c65a0d6e0d3f3d9193c4")
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
PLATFORM_GYP_FILE="common/jpeg/libjea.gyp"

inherit cros-camera cros-workon

DESCRIPTION="Library for using JPEG Encode Accelerator in Chrome"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"

RDEPEND="media-libs/cros-camera-libcamera_common"

DEPEND="${RDEPEND}
	media-libs/cros-camera-libcamera_ipc
	virtual/pkgconfig"

src_unpack() {
	cros-camera_src_unpack
}

src_install() {
	dolib.a "${OUT}/libjea.pic.a"

	cros-camera_doheader include/cros-camera/jpeg_encode_accelerator.h

	cros-camera_dopc common/jpeg/libjea.pc.template
}
