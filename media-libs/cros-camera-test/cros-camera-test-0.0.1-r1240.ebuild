# Copyright 2017 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CROS_WORKON_COMMIT="33a8fa386180a5fce9d1ab59a0d2e9a18521f378"
CROS_WORKON_TREE=("f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6" "67326aa19f1aee5051aefd50a959b82d12643540" "c176cf83426f5748d581662c486a8ff18639fd75" "ca09ab791c51e2070cf6459ddd1f82858166c39a" "a55b5c7cb59d379ad7bf9c9da3a168f999f675dc" "d031af9b5360ae0f704f4d6ef23b234fc46152cf" "5b87e97f3ddb9634fb1d975839c28e49503e94f8")
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_LOCALNAME="../platform2"
# TODO(crbug.com/809389): Avoid directly including headers from other packages.
CROS_WORKON_SUBTREE=".gn camera/build camera/camera3_test camera/common camera/include chromeos-config common-mk"
CROS_WORKON_OUTOFTREE_BUILD="1"
CROS_WORKON_INCREMENTAL_BUILD="1"

PLATFORM_SUBDIR="camera/camera3_test"

inherit cros-camera cros-workon platform

DESCRIPTION="Chrome OS camera HAL native test."

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE="-asan"

RDEPEND="
	>=chromeos-base/cros-camera-libs-0.0.1-r34:=
	chromeos-base/cros-camera-android-deps
	media-libs/libexif
	media-libs/libsync
	media-libs/minigbm
	virtual/jpeg:0"

DEPEND="${RDEPEND}
	dev-cpp/gtest:=
	media-libs/libyuv
	virtual/pkgconfig"
