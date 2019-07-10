# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CROS_WORKON_COMMIT="367fc705d107932356405d25e3427bba9332979a"
CROS_WORKON_TREE=("dc1506ef7c8cfd2c5ffd1809dac05596ec18773c" "7134e391e4c04513211b250b665951820d5b0bbd" "e1c3f72095079c5cb59322a07192c8faf2a9b15c" "2624ca1aeb7f546093c8cac8244297955cb1481d" "79935d3039bad820fa03c8bded635ad197ad74ab" "ea6e2e1b6bec83695699ef78cec2f03321d97dd7" "6977f02f05507ea491bf922951ddb140caa4b5b8")
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
