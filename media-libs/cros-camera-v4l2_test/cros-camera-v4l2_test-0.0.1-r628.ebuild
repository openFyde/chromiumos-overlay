# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=6

CROS_WORKON_COMMIT="4481e87cb1f0478266277ee28a31db1b8e53e3b6"
CROS_WORKON_TREE=("e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb" "5d4b5fc0092e08daba635f52f88ea2ad5ca84895" "dbb0a8564398d498a3486b7870d977d7570d4e23" "7648fcd7524deceb545b0078bbc48dff4e64cb4d" "e498ee2a7b969b42a37b5ea7e758fc6482ab2ae5" "8a107d83e7e0a12f330005e0cd66720e3d854a2e")
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_LOCALNAME="../platform2"
CROS_WORKON_SUBTREE=".gn camera/build camera/common camera/include camera/hal/usb common-mk"
CROS_WORKON_OUTOFTREE_BUILD="1"
CROS_WORKON_INCREMENTAL_BUILD="1"

PLATFORM_SUBDIR="camera/hal/usb/v4l2_test"

inherit cros-camera cros-workon platform

DESCRIPTION="Chrome OS camera V4L2 test."

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"

RDEPEND="
	chromeos-base/cros-camera-libs
	chromeos-base/libbrillo:=
	dev-cpp/gtest:=
	dev-libs/re2:=
	media-libs/libyuv
	virtual/jpeg:0"

DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_install() {
	platform_src_install
	dobin "${OUT}/camera_characteristics_test"
	dobin "${OUT}/media_v4l2_is_capture_device"
	dobin "${OUT}/media_v4l2_test"
}
