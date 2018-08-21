# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CROS_WORKON_COMMIT=("922b8ecfd89b62702982cf10ddf4f9b8a1507ed5" "a0f143cc50fb2fef088525e8da2fb8374427ddc8")
CROS_WORKON_TREE=("6589055d0d41e7fc58d42616ba5075408d810f7d" "52f1325cf270a13e8df427b912e44d373c99f757" "15c6d2b3c8226508b7434556acbda449e788a508" "04d2f915e83148f85ce085e7ee18f2506ec85a47" "335c01060e7415af95705bf53ce03552097ba3cd")
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
PLATFORM_GYP_FILE="common/jpeg/libjda.gyp"

inherit cros-camera cros-workon

DESCRIPTION="Library for using JPEG Decode Accelerator in Chrome"

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
	dolib.a "${OUT}/libjda.pic.a"

	cros-camera_doheader include/cros-camera/jpeg_decode_accelerator.h

	cros-camera_dopc common/jpeg/libjda.pc.template
}
