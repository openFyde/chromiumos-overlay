# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CROS_WORKON_COMMIT="a7c9a02bd47c0140db87ed7c41f860c04022e0cf"
CROS_WORKON_TREE=("e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb" "d58be6324ba2a1d0452d23bafb39c869c5ed2cd6" "03892a77e7a3a380c7aa47d309c3bbec6f94b5a2" "d6fa10cef5a85a2615e1273240c221a553b43cc3" "84441b28a7584715021e2faf292e0cf5864ea8bf" "1c07dc76ec4881aeccc6c6151786dc26bf5f73c0" "2834854981f88e2b81fefd49c590185a31f2b1f1")
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
