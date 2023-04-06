# Copyright 2019 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CROS_WORKON_COMMIT="926ef3de486806b896b8979dd4a9e26458731787"
CROS_WORKON_TREE=("f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6" "67326aa19f1aee5051aefd50a959b82d12643540" "ca09ab791c51e2070cf6459ddd1f82858166c39a" "13a1732d79ff7a78aec895914901f7207cb5770c" "dbb36a9b1d66333ad7c4f45838c2be5cd7056682" "a55b5c7cb59d379ad7bf9c9da3a168f999f675dc" "42d4c946578d8a8457ffbcc4ce9125341f8f42f1" "717278285b7794be7f759aa9721ff66a3a4033d9" "5b87e97f3ddb9634fb1d975839c28e49503e94f8")
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
