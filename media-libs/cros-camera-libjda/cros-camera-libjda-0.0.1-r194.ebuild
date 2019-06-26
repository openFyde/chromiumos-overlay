# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CROS_WORKON_COMMIT="04d44dead916a72d106cc8c0626e793210c1b9dd"
CROS_WORKON_TREE=("dc1506ef7c8cfd2c5ffd1809dac05596ec18773c" "c1d6f47d810546f7412d95791a85fb4d35831af3" "9070f9f3e25e1440437a8814ac08615f3d9f8be4" "2624ca1aeb7f546093c8cac8244297955cb1481d" "6e314ded1aca274c35b5b5fce743f749195aa2a9" "85e0104104aae2c94fdb541e99b3e41c2d472eef" "e1806dff039cc88628f7e140a13a2ca5cefa71cf")
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_LOCALNAME="../platform2"
CROS_WORKON_SUBTREE=".gn camera/build camera/common camera/include camera/mojo common-mk metrics"
CROS_WORKON_OUTOFTREE_BUILD="1"
CROS_WORKON_INCREMENTAL_BUILD="1"

PLATFORM_SUBDIR="camera"
PLATFORM_GYP_FILE="common/jpeg/libjda.gyp"

inherit cros-camera cros-workon platform

DESCRIPTION="Library for using JPEG Decode Accelerator in Chrome"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"

RDEPEND="media-libs/cros-camera-libcamera_common"

DEPEND="${RDEPEND}
	chromeos-base/metrics
	media-libs/cros-camera-libcamera_ipc
	virtual/pkgconfig"

src_install() {
	dolib.a "${OUT}/libjda.pic.a"

	cros-camera_doheader include/cros-camera/jpeg_decode_accelerator.h

	cros-camera_dopc common/jpeg/libjda.pc.template
}
