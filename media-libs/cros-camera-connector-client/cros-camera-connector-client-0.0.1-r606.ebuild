# Copyright 2020 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="136c3e114b65f2c6c5f026376c2e75c73c2478a3"
CROS_WORKON_TREE=("f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6" "2ad8679ea3a8f3e8a2509b4b05585f22f2dc373b" "2416996346084d58da875c166f68e246f68c8f8b" "f4b6ba0372052821547e5e2094fc6602f8a61ce8" "c901c5ae2c93caaacd85170e42bc7275c199450f" "eb1fe3bef742a865c350a9d742e224d4077efbd5")
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

RDEPEND="chromeos-base/cros-camera-libs"

DEPEND="${RDEPEND}
	x11-libs/libdrm"

BDEPEND="virtual/pkgconfig"
