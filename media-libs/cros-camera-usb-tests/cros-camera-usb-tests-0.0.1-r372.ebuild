# Copyright 2019 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="8753db580474608c9a317d2089ef38658e0ee7f3"
CROS_WORKON_TREE=("f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6" "6a208d3bace261bf98c78f08d147fe0e348a362d" "db263a10cec3fc724e82e1f6615e51abad77eae7" "8382512685d679dd033d07c31295df8160820113" "ac22cf3b68ffe9e26404c947cdee4bf228269670" "6350979dbc8b7aa70c83ad8a03dded778848025d")
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_LOCALNAME="../platform2"
CROS_WORKON_SUBTREE=".gn camera/build camera/common camera/include camera/hal/usb common-mk"
CROS_WORKON_OUTOFTREE_BUILD="1"
CROS_WORKON_INCREMENTAL_BUILD="1"

PLATFORM_SUBDIR="camera/hal/usb/tests"

inherit cros-camera cros-workon platform

DESCRIPTION="Chrome OS USB camera tests."

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"

RDEPEND="
	!media-libs/cros-camera-v4l2_test
	chromeos-base/cros-camera-libs
	chromeos-base/libbrillo:=
	dev-cpp/gtest:=
	dev-libs/re2:=
	media-libs/libyuv
	virtual/jpeg:0
	virtual/libusb:1
"

DEPEND="${RDEPEND}
	virtual/pkgconfig"
