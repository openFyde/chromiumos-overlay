# Copyright 2019 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CROS_WORKON_COMMIT="bf4306015dd5762c19d5ea0c4fe22061cb4c9c79"
CROS_WORKON_TREE=("f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6" "2ad8679ea3a8f3e8a2509b4b05585f22f2dc373b" "3c5ca12b75bf692fb7065af7ae3e0a181fb30ce9" "665f40b8f6ee749f9c0993f0f07b482414b6486f" "2c700a481dc1c12c228ad3bd2f25199362b28d58" "40a1c83b03a8d998cc3846a40c3ee320d6c0129f" "a0af00390c3d3c63903578edd1d7c7cb504a8699" "d6819ed74e00aafbee3e7e0524f5a06282d0bebb" "6836462cc3ac7e9ff3ce4e355c68c389eb402bff")
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
