# Copyright 2022 The ChromiumOS Authors.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="ed2a9a5d855d5350306b977e5f8ff1902e7db4b9"
CROS_WORKON_TREE=("f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6" "2ad8679ea3a8f3e8a2509b4b05585f22f2dc373b" "b017f83d28a29a971d1a48af35894ff14343d1f3" "afa2620dbfb5e717145470abb08ba87a9f69d4d2" "cca028a152e5133236b2b7dd8b97ca79660968c2" "546d612834bb46518d8ed157a8923c49016e2fb5" "5a857fb996a67f6c9781b916ba2d6076e9dcd0a6")
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
