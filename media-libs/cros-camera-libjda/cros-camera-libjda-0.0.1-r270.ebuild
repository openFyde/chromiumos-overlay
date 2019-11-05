# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CROS_WORKON_COMMIT="fb2df820af54bb41e1d8bc3f899a6e04a5a7fad5"
CROS_WORKON_TREE=("e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb" "d58be6324ba2a1d0452d23bafb39c869c5ed2cd6" "95792eb9452c8e29329d404fbffc4f600382248f" "f7f16d5474f139cf453b503655a8e6936cb52e88" "2ba22b88ed6c3fdb6b720b3a0c1bc4c0a17f1afa" "70d83bbed2cc71b12ba96acb151f090af819c990" "0fb784e506cbf071c9e2700aa93bf591a4f624a1")
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
	virtual/pkgconfig"

src_install() {
	dolib.a "${OUT}/libjda.pic.a"

	cros-camera_doheader ../../../include/cros-camera/jpeg_decode_accelerator.h

	cros-camera_dopc ../libjda.pc.template
}
