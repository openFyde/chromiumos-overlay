# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="7829c4a56ac4b2ab01d0742ade61cd6ee5be5f88"
CROS_WORKON_TREE=("e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb" "c920da127f686c434165b6056b1cd740f228df6b" "bc54278f809cf701d0e479575fef5a3081d4a611" "1d1535ce93b5af1f78dbf1665e00cee8364c426a" "ffccaa8b7bb1b063ae1051517543023ce055ef35" "52a8a8b6d3bbca5e90d4761aa308a5541d52b1bb")
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_LOCALNAME="../platform2"
CROS_WORKON_SUBTREE=".gn camera/build camera/common camera/include camera/mojo common-mk"
CROS_WORKON_OUTOFTREE_BUILD="1"
CROS_WORKON_INCREMENTAL_BUILD="1"

PLATFORM_SUBDIR="camera/common/libcamera_connector"

inherit cros-camera cros-workon platform

DESCRIPTION="Chrome OS camera connector for simpler uses."

LICENSE="BSD-Google"
KEYWORDS="*"

BDEPEND="virtual/pkgconfig"

RDEPEND="
	media-libs/cros-camera-libcamera_common
	media-libs/cros-camera-libcamera_ipc
	media-libs/cros-camera-libcamera_metadata
	media-libs/libsync"

DEPEND="${RDEPEND}
	media-libs/cros-camera-android-headers
	media-libs/cros-camera-libcamera_connector_headers
	x11-libs/libdrm"

src_install() {
	platform_src_install
	dolib.so "${OUT}/lib/libcamera_connector.so"
	cros-camera_dopc ../libcamera_connector.pc.template
}

