# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CROS_WORKON_COMMIT="4047f2fc6b2a9d24681fd5e3b25972e30815a100"
CROS_WORKON_TREE=("dc1506ef7c8cfd2c5ffd1809dac05596ec18773c" "c1d6f47d810546f7412d95791a85fb4d35831af3" "45464e41994abf1413eebb9ffcc37830338a1cf4" "4ad7b2111cccd3e5e342184d5cfc3ff20201e4b2" "0b93e0b33b51b0b0b6fdeb4bd58bf208654fe66c" "0b59dbfa6eda71d101f7be5cc518450e4b5d1be4" "dd1bdf4ae97b0742bce836b810f1d7e4104bd47c")
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
