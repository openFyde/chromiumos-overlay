# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CROS_WORKON_COMMIT=("07a3846a38c2225f1fb22742d56727d0d58e2a18" "aad546f2a06fd7cbc9f00c573d33f2e2a4402afb")
CROS_WORKON_TREE=("6589055d0d41e7fc58d42616ba5075408d810f7d" "cfdd1bad3a718555768158673244f1c2c0943d6a" "0f93a06541157726fd56da5dc65eb9f25b19756e" "8f3859492d0228b565f17f02fe138f81617c6415" "ce18fba0c0aae39b3917fd9511c2a282b7fb703b")
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
