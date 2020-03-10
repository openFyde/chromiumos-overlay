# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CROS_WORKON_COMMIT="fbbbd33a803ae04ce7c3a9d9086ca1cea0130980"
CROS_WORKON_TREE=("e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb" "d58be6324ba2a1d0452d23bafb39c869c5ed2cd6" "018d4b823f729d0b32dab4d450df7d4125845bec" "94cca01db02ec757d76d672c3fc0d4eea9a91be8" "5e3ca9673adc2f2840871ff69c318e2b191592fd" "861f66e9f884ebb293fb541a5501f183861a2dda" "f80bd0721a67127e04dde4362dfcb1c39051698e")
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

RDEPEND="
	media-libs/cros-camera-libcamera_common
	media-libs/cros-camera-libcamera_ipc"

# cros-camera-libcbm is needed here because this package uses
# //camera/common:libcamera_metrics rule. It doesn't directly use the package,
# but another rule in that BUILD.gn requires libcbm upon opening the .gn file.
# See crbug.com/995162 for detail.
DEPEND="${RDEPEND}
	chromeos-base/metrics
	media-libs/cros-camera-libcbm
	media-libs/libyuv
	virtual/pkgconfig"

src_install() {
	dolib.a "${OUT}/libjda.pic.a"

	cros-camera_doheader ../../../include/cros-camera/jpeg_decode_accelerator.h

	cros-camera_dopc ../libjda.pc.template
}
