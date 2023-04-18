# Copyright 2019 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CROS_WORKON_COMMIT="5a59ac17a84eb6b019c5a4eab7b01bef6d7d1ae9"
CROS_WORKON_TREE=("f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6" "6a208d3bace261bf98c78f08d147fe0e348a362d" "db263a10cec3fc724e82e1f6615e51abad77eae7" "13a1732d79ff7a78aec895914901f7207cb5770c" "ac22cf3b68ffe9e26404c947cdee4bf228269670" "a9a0ffa59bdd3d5f4dbcef883804d59c3b909b69" "42d4c946578d8a8457ffbcc4ce9125341f8f42f1" "f9559bb24ca0c0f08cfd600f978e909fd34f8d4e" "6350979dbc8b7aa70c83ad8a03dded778848025d")
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
