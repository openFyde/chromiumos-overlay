# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CROS_WORKON_COMMIT="27646f904cc51692f80ca7aa1385a104b65373a7"
CROS_WORKON_TREE=("dc1506ef7c8cfd2c5ffd1809dac05596ec18773c" "7134e391e4c04513211b250b665951820d5b0bbd" "50312c1bd8a930a884ba51d4d42e393804768f00" "a060184c6f947aa11f7e4e3a0e062fde7629cc24" "79935d3039bad820fa03c8bded635ad197ad74ab" "ea6e2e1b6bec83695699ef78cec2f03321d97dd7" "f5487f98fc92ea0a3d4a4f9d6198fe29c400af56")
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_LOCALNAME="../platform2"
CROS_WORKON_SUBTREE=".gn camera/build camera/common camera/include camera/mojo common-mk metrics"
CROS_WORKON_OUTOFTREE_BUILD="1"
CROS_WORKON_INCREMENTAL_BUILD="1"

PLATFORM_SUBDIR="camera/common/jpeg/libjda"

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

	cros-camera_doheader ../../../include/cros-camera/jpeg_decode_accelerator.h

	cros-camera_dopc ../libjda.pc.template
}
