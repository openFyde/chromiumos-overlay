# Copyright 2022 The ChromiumOS Authors.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="51de882c758cbb9ae92c7ade70469069d0ea6540"
CROS_WORKON_TREE=("f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6" "2ad8679ea3a8f3e8a2509b4b05585f22f2dc373b" "ca26ac8c623c448f88785fd2328bfb7fecc6b995" "73eb6054a7a350e5577ac96393cb123713fb63b9" "2a732d74405761e6ffe5bcc97cbcd79de8741778" "546d612834bb46518d8ed157a8923c49016e2fb5" "0f4044624c1fabe638a8289e62ec74756aa62176")
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
