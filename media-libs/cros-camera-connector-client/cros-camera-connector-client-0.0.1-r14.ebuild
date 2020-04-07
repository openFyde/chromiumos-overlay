# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="4ba6236117b1e4b27e384229b671fa89d7ac9ee9"
CROS_WORKON_TREE=("e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb" "d58be6324ba2a1d0452d23bafb39c869c5ed2cd6" "8b5e03ae2be77a84af91c63ae160109b4150df0d" "3b0df27cc9815119601a11574ff59b81d12be191" "e92c12397252af71303abe9bae0819944742cd57" "dea48af07754556aac092c0830de0b1ab410077b")
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_LOCALNAME="../platform2"
CROS_WORKON_SUBTREE=".gn camera/build camera/tools/connector_client camera/common camera/include common-mk"
CROS_WORKON_OUTOFTREE_BUILD="1"
CROS_WORKON_INCREMENTAL_BUILD="1"

PLATFORM_SUBDIR="camera/tools/connector_client"

inherit cros-camera cros-workon platform

DESCRIPTION="A simple package that exercises cros-camera-libcamera_connector"

LICENSE="BSD-Google"
KEYWORDS="*"

RDEPEND="media-libs/cros-camera-libcamera_connector"

BDEPEND="virtual/pkgconfig"

src_install() {
	dobin "${OUT}/cros_camera_connector_client"
}
