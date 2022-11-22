# Copyright 2022 The ChromiumOS Authors.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="a42a6e4d6b5173a43000764b67fdd6c6fe019c3f"
CROS_WORKON_TREE=("f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6" "3a939e262dbbb04bab2434b9e34a18e1f4cbda60" "07f88b9f241d3eb5e9546c08c0071cf056d8d182" "6b232ae4bebf9d34b25324395057d2f3a077c74d" "13256dd5a9ebc74eb559a2a7b27cf13912afdc7b" "a0af00390c3d3c63903578edd1d7c7cb504a8699" "ebcce78502266e81f55c63ade8f25b8888e2c103")
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
	media-libs/libsync:=
	media-libs/libyuv:="

BDEPEND="${RDEPEND}
	virtual/pkgconfig:="

src_install() {
	platform_src_install
	cros-camera_dohal "${OUT}/lib/libcamera_hal.so" fake.so
}
