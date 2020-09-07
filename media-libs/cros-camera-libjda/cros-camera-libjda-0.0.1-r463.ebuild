# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CROS_WORKON_COMMIT="e29961eb7cfb7d07ae6b27e3d77c5430b8325cff"
CROS_WORKON_TREE=("e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb" "d58be6324ba2a1d0452d23bafb39c869c5ed2cd6" "652cbb30166c56fc3cc8f645d007547c35fe062a" "4cc600d625ecfdac13d984d9190d63a8970b0a4b" "ab72b93074396d3428b557e2e00d64f487fab1e1" "b6b10e03115551b69ba9e2502b15d5467adcd107" "86cbea444f4155f2ac059fd59747fe5000df718d")
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
	>=chromeos-base/metrics-0.0.1-r3152
	media-libs/cros-camera-libcbm
	media-libs/libyuv
	virtual/pkgconfig"

src_install() {
	dolib.a "${OUT}/libjda.pic.a"

	cros-camera_doheader ../../../include/cros-camera/jpeg_decode_accelerator.h

	cros-camera_dopc ../libjda.pc.template
}
