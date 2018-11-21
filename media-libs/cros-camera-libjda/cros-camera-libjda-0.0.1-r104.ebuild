# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CROS_WORKON_COMMIT=("ab98aa910573e0a6b6dc0912a1ff1abfd5677f54" "e6bdc02b0fb28f75832c012bcadd6c826c0c6a43")
CROS_WORKON_TREE=("6589055d0d41e7fc58d42616ba5075408d810f7d" "637f9de8cd61b481758796da223f78d4a137397d" "3ef1cf278293474828fe440e490f1e5c740f2fb6" "bfef2802b8fc411b9769b3112b451ad72ae0de7f" "1a4b7a7926e6533605c6bf09c5726f6d18045350")
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
