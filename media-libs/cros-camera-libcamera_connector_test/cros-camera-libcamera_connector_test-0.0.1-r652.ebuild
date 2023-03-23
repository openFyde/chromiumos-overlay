# Copyright 2020 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="35e6d96a1b4b15cf92029ab3f1794f37b6619931"
CROS_WORKON_TREE=("f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6" "67326aa19f1aee5051aefd50a959b82d12643540" "6014c1a1e347dc3a6806a9dfb63e39adee5dc63b" "5173d4b89e762b0b8012bdf26edff3b6de7eeda3" "017dc03acde851b56f342d16fdc94a5f332ff42e")
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_LOCALNAME="../platform2"
CROS_WORKON_SUBTREE=".gn camera/build camera/common camera/include common-mk"
CROS_WORKON_OUTOFTREE_BUILD="1"
CROS_WORKON_INCREMENTAL_BUILD="1"

PLATFORM_SUBDIR="camera/common/libcamera_connector_test"

inherit cros-camera cros-workon platform

DESCRIPTION="Chrome OS camera connector test."

LICENSE="BSD-Google"
KEYWORDS="*"

RDEPEND="
	chromeos-base/cros-camera-libs:=
	dev-cpp/gtest:=
	media-libs/libyuv
	virtual/jpeg:0"

DEPEND="${RDEPEND}"

BDEPEND="virtual/pkgconfig"
