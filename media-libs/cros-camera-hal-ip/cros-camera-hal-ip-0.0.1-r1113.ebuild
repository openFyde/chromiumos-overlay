# Copyright 2019 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CROS_WORKON_COMMIT="23bf1b0d77f9d757ae3be4b9c349bdfe3bfba3ae"
CROS_WORKON_TREE=("f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6" "67326aa19f1aee5051aefd50a959b82d12643540" "f95a8c6f6415e4118a8ca857cc7b19ee75bde542" "13a1732d79ff7a78aec895914901f7207cb5770c" "754dadfa1265627a75461fae38969d2214783da8" "8382512685d679dd033d07c31295df8160820113" "42d4c946578d8a8457ffbcc4ce9125341f8f42f1" "6d3b76b402ee2ad0e719b1b1242c3e797c19d2e1" "5b87e97f3ddb9634fb1d975839c28e49503e94f8")
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
