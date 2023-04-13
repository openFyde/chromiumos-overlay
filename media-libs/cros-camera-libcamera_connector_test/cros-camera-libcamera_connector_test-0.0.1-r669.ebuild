# Copyright 2020 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="cbba8c413a1cae7db84ea0dcd910b4f4a01ce167"
CROS_WORKON_TREE=("f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6" "67326aa19f1aee5051aefd50a959b82d12643540" "3ddaa6dd2fd388bc8c3dfcf10e359010158cdd37" "8382512685d679dd033d07c31295df8160820113" "b9c8b8315a832ea4cfd3cb10367bc58e9a3ecb2a")
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

DEPEND="
	${RDEPEND}
	media-libs/cros-camera-libcamera_connector_headers
"

BDEPEND="virtual/pkgconfig"
