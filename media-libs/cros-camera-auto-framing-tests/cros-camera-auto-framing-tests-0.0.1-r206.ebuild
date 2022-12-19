# Copyright 2022 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="a03cc84f987e4ae46540c1504e642c1db9ab8c98"
CROS_WORKON_TREE=("f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6" "2ad8679ea3a8f3e8a2509b4b05585f22f2dc373b" "be3889ade895715816396f918ac139d1cc944c3f" "7e58eaa2e768ae8112ab3b362a1d789a1f73e78e" "25c0e94cb9e00d546d5f2b4e22ba5efe4b6306f5" "fb991ada697f993a8282997d62671c49daef274f" "a0af00390c3d3c63903578edd1d7c7cb504a8699" "2bbf53b0300ba923b6530720b27502e1469b2ee9" "0c3a30cd50ce72094fbd880f2d16d449139646a2" "7ddb8f962dd6611aef849f6a4c0ed7268cedb699" "6da0a978ba1edbe645822f82ddb2493d34ecf9f7" "fd6923d33e6c347f8d488bc087ddcbd0d53d4fea" "852e3fb47c6c7bc3baf28d7cb71766ea4aeee96e" "1df96416290731160d582fa8ffa8f156b2fbac53")
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_LOCALNAME="../platform2"
# iioservice/ is included just to make sandbox happy when running `gn gen`.
CROS_WORKON_SUBTREE=".gn camera/build camera/features camera/include camera/gpu camera/common camera/mojo chromeos-config common-mk iioservice/libiioservice_ipc iioservice/mojo metrics ml_core ml_core/mojo"
CROS_WORKON_OUTOFTREE_BUILD="1"
CROS_WORKON_INCREMENTAL_BUILD="1"

PLATFORM_SUBDIR="camera/features/auto_framing/tests"

inherit cros-workon platform

DESCRIPTION="ChromeOS Camera Auto-framing feature tests"

LICENSE="BSD-Google"
KEYWORDS="*"

IUSE="camera_feature_auto_framing camera_feature_face_detection"

BDEPEND="virtual/pkgconfig"

RDEPEND="
	chromeos-base/chromeos-config-tools:=
	chromeos-base/cros-camera-android-deps:=
	dev-cpp/gtest:=
	media-libs/cros-camera-libfs:=
	media-libs/libexif:=
	media-libs/libsync:=
	media-libs/minigbm:=
	virtual/opengles:=
	x11-libs/libdrm:=
"

DEPEND="
	${RDEPEND}
	chromeos-base/metrics:=
	media-libs/libyuv:=
	x11-drivers/opengles-headers:=
"

src_configure() {
	cros_optimize_package_for_speed
	platform_src_configure
}

src_install() {
	dobin "${OUT}"/auto_framing_test
	platform_src_install
}
