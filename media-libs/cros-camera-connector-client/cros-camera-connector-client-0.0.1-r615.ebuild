# Copyright 2020 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="7e6a8406b63daa4577b827c85c139242210a5c5c"
CROS_WORKON_TREE=("f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6" "2ad8679ea3a8f3e8a2509b4b05585f22f2dc373b" "2416996346084d58da875c166f68e246f68c8f8b" "9e34120919c688fdbf7aa3115c84a409ffdaa82c" "86f67aee61b7bbac965e96820455a837bb4401d5" "6836462cc3ac7e9ff3ce4e355c68c389eb402bff")
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
