# Copyright 2022 The ChromiumOS Authors.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="6d39b093239f638a02819b52a4065112d5305ec0"
CROS_WORKON_TREE=("f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6" "3acfc95dd3569b0195030d53f6df21df011e12cd" "3b4d9dcd2b55775db0a92fd0c6b32f371bec0f19" "b6a455d9c2be2c6f3eb09f29f5dada9281e8775f" "2bbd437fade0a66ecdaa82c7cf22f71cb870df3b" "0459d2d800b5b9edfd24eec4c6fe63167d146835" "c70c24e7eeb0c8aad6108bedde29b6984f63cd54")
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_LOCALNAME="../platform2"
# TODO(b/187784160): Avoid directly including headers from other packages.
CROS_WORKON_SUBTREE=".gn camera/build camera/common camera/hal/fake camera/include camera/mojo common-mk"
CROS_WORKON_OUTOFTREE_BUILD="1"
CROS_WORKON_INCREMENTAL_BUILD="1"

PLATFORM_SUBDIR="camera/hal/fake"

inherit cros-camera cros-workon platform

DESCRIPTION="ChromeOS fake camera HAL."

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE=""

RDEPEND="
	chromeos-base/cros-camera-android-deps:=
	chromeos-base/cros-camera-libs:="

BDEPEND="${RDEPEND}
	virtual/pkgconfig:="

src_install() {
	platform_src_install
	cros-camera_dohal "${OUT}/lib/libcamera_hal.so" fake.so
}
