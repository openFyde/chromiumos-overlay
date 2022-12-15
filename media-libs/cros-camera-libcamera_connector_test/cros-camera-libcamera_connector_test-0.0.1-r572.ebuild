# Copyright 2020 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="d9b35688d673fc3df047212a2ba0056d35870b95"
CROS_WORKON_TREE=("f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6" "2ad8679ea3a8f3e8a2509b4b05585f22f2dc373b" "99cbd7d4770e12a6a30630de5bb84661b1ad421b" "7e58eaa2e768ae8112ab3b362a1d789a1f73e78e" "232eeac462515f4e1460770a38b8ac52bef0adec")
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

src_install() {
	platform_src_install
	dobin "${OUT}/cros_camera_connector_test"
}
