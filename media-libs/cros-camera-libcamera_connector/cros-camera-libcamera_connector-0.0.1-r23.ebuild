# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="e567b9e94d0d0a015e44f3c6304b7252ddb47413"
CROS_WORKON_TREE=("e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb" "d58be6324ba2a1d0452d23bafb39c869c5ed2cd6" "adfdc5b61d66eb38a9b3910fdc990e0b9ebfdd7a" "e92c12397252af71303abe9bae0819944742cd57" "093c7a01cb65cb24871c5a2ce7c2bdd0a536fccf" "473665059c4645c366e7d3f0dfba638851176adc")
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
	x11-libs/libdrm"

src_install() {
	dolib.so "${OUT}/lib/libcamera_connector.so"
	cros-camera_dopc ../libcamera_connector.pc.template
	cros-camera_doheader ../../include/cros-camera/camera_service_connector.h
}

