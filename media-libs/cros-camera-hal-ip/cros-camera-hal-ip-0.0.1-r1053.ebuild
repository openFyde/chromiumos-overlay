# Copyright 2019 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CROS_WORKON_COMMIT="1b36d01509d2cb62edb84eff26c58edf518ea748"
CROS_WORKON_TREE=("f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6" "2ad8679ea3a8f3e8a2509b4b05585f22f2dc373b" "ca26ac8c623c448f88785fd2328bfb7fecc6b995" "13a1732d79ff7a78aec895914901f7207cb5770c" "29f9cee2a6fe34fc635513f91b18f6a73d6b5062" "2a732d74405761e6ffe5bcc97cbcd79de8741778" "546d612834bb46518d8ed157a8923c49016e2fb5" "d1531884133da981fe6414dbcd67713d10efeef7" "ca7895485a50f354a0c396417657ff67fbbdf40f")
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_LOCALNAME="../platform2"
CROS_WORKON_SUBTREE=".gn camera/build camera/common camera/hal/ip camera/hal/usb camera/include camera/mojo chromeos-config common-mk"
CROS_WORKON_OUTOFTREE_BUILD="1"
CROS_WORKON_INCREMENTAL_BUILD="1"

PLATFORM_SUBDIR="camera/hal/ip"

inherit cros-camera cros-workon platform

DESCRIPTION="Chrome OS IP camera HAL v3."

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
RDEPEND="
	chromeos-base/chromeos-config-tools
	chromeos-base/cros-camera-android-deps
	chromeos-base/cros-camera-libs
	media-libs/libsync"

DEPEND="${RDEPEND}
	virtual/pkgconfig"

platform_pkg_test() {
	platform test_all
}
