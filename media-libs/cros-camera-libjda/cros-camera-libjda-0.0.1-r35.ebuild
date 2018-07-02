# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CROS_WORKON_COMMIT=("4d1024a145fe5e225700365d70b6e77f81c94606" "85be3314004e8a14be3f9a6dcefbecc40dd7bcdc")
CROS_WORKON_TREE=("6589055d0d41e7fc58d42616ba5075408d810f7d" "d3b0291c98e3e595e4e8bfb534331d32f45c38a3" "0317ae0ee6da82324dfb7e3166f9c7ce5ac42f95" "04d2f915e83148f85ce085e7ee18f2506ec85a47" "85db6764c18b2cd6e849d2c5e5cd3138c23f3563")
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
