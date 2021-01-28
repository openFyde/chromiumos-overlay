# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CROS_WORKON_COMMIT="7fa17b92a75abc198c08010be1c93a07cd93a6d3"
CROS_WORKON_TREE=("e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb" "c920da127f686c434165b6056b1cd740f228df6b" "974e5365ff6753348c20b23c8270c561383ce5d4" "b321c71344a87bd236ee4d188dc0ab88fa25d8d3" "6fb2e05a1cd872b5f2b18df2a4991d7614e78e13" "039ed44189c17a7037215fc778a6f1fcb96b1433")
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_LOCALNAME="../platform2"
CROS_WORKON_SUBTREE=".gn camera/build camera/common camera/include camera/mojo common-mk"
CROS_WORKON_OUTOFTREE_BUILD="1"
CROS_WORKON_INCREMENTAL_BUILD="1"

PLATFORM_SUBDIR="camera/common/libcamera_ipc"

inherit cros-camera cros-workon platform

DESCRIPTION="Chrome OS HAL IPC util."

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"

RDEPEND="media-libs/cros-camera-libcamera_metadata"

DEPEND="${RDEPEND}
	media-libs/cros-camera-libcamera_common
	virtual/pkgconfig"

src_configure() {
	cros_optimize_package_for_speed
	platform_src_configure
}

src_install() {
	platform_src_install
	dolib.so "${OUT}/lib/libcamera_ipc.so"
	dolib.a "${OUT}/libcamera_ipc_mojom.a"

	cros-camera_doheader \
		../../include/cros-camera/camera_mojo_channel_manager_token.h

	cros-camera_dopc ../libcamera_ipc.pc.template
}
