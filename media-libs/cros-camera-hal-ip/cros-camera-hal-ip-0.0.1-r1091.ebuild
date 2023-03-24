# Copyright 2019 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CROS_WORKON_COMMIT="d7e74ccc2b4ef743082cb39b4a472bdc4a85838b"
CROS_WORKON_TREE=("f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6" "67326aa19f1aee5051aefd50a959b82d12643540" "40e596469cda2f08b17e2fced9094dddde8bb588" "13a1732d79ff7a78aec895914901f7207cb5770c" "2fd52c512942e12a9ba677d8441d1bd2f4058fb6" "5173d4b89e762b0b8012bdf26edff3b6de7eeda3" "0dd00d630f9617164a5faa8c5dbaf623440a7bcc" "f9c7431caf7b64df59390da12d5015c7b934da90" "017dc03acde851b56f342d16fdc94a5f332ff42e")
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
