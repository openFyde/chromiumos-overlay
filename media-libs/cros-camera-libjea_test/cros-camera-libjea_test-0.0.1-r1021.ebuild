# Copyright 2018 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CROS_WORKON_COMMIT="bb9afe6773e6b4e0927003b9b85087f875eef03e"
CROS_WORKON_TREE=("f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6" "2ad8679ea3a8f3e8a2509b4b05585f22f2dc373b" "d5e67458f90f1b48f415dec5473521ad707e7927" "a107bda06bdcf45088d2aecf0d50b69804adfd69" "017dc03acde851b56f342d16fdc94a5f332ff42e")
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_LOCALNAME="../platform2"
CROS_WORKON_SUBTREE=".gn camera/build camera/common camera/include common-mk"
CROS_WORKON_OUTOFTREE_BUILD="1"
CROS_WORKON_INCREMENTAL_BUILD="1"

PLATFORM_SUBDIR="camera/common/jpeg/libjea_test"

inherit cros-camera cros-workon platform

DESCRIPTION="End to end test for JPEG encode accelerator"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"

RDEPEND="
	chromeos-base/cros-camera-android-deps
	chromeos-base/cros-camera-libs
	dev-cpp/gtest:=
	media-libs/libyuv"

DEPEND="${RDEPEND}"
