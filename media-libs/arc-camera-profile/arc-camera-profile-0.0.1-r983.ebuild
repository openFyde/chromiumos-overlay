# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CROS_WORKON_COMMIT="bb55040a9a7506dac6aaf3e62fcb5e6976ed36a5"
CROS_WORKON_TREE=("e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb" "4be8d3ae5664634825afc2e6e4b8c24816ee9b9e" "60c4cba4948f37080b72178b7f7fd48679cc36d4" "cd2b0b6a2af0012042cdfbc419f75fbd6d2493c8" "e8fa0c152d7508f5490de37be923f510d16adb23" "f162a50ee5e3be796b55be465658ddaafbee87e3" "3c24635bdb70bad9c4066b34bc5ced871ab8294a")
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_LOCALNAME="../platform2"
CROS_WORKON_SUBTREE=".gn camera/build camera/common camera/hal/usb camera/include camera/tools common-mk"
CROS_WORKON_OUTOFTREE_BUILD="1"
CROS_WORKON_INCREMENTAL_BUILD="1"

PLATFORM_SUBDIR="camera/tools/generate_camera_profile"

inherit cros-camera cros-workon platform

DESCRIPTION="Runtime detect the number of cameras on device to generate
corresponding media_profiles.xml."

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"

RDEPEND=""

DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_install() {
	dobin "${OUT}/generate_camera_profile"
}
