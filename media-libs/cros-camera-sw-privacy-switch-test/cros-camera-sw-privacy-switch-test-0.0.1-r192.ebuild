# Copyright 2022 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="820173ff909d68e585138e05a1660e2e92333afd"
CROS_WORKON_TREE=("f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6" "2ad8679ea3a8f3e8a2509b4b05585f22f2dc373b" "eef8ac89e44dd21fde4d4406b2935595280b305a" "2304a37a8a107ff4cf612c9704679c8096f898c7" "7010a5d9405cc702f23ac245cff1c1a7a877ad4e" "fe44935c56d24162dece28a2533337e28d2cd52d" "a0af00390c3d3c63903578edd1d7c7cb504a8699" "57e0be63e6c4ad6628bf18e46d669329e5240e57" "5a857fb996a67f6c9781b916ba2d6076e9dcd0a6" "7ddb8f962dd6611aef849f6a4c0ed7268cedb699" "6da0a978ba1edbe645822f82ddb2493d34ecf9f7" "b0e3863eb7f2ff9a3c1f75589366d018c639f9b5" "462f2be6983abed65ecb6374eb180661346be7a4" "1df96416290731160d582fa8ffa8f156b2fbac53")
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_LOCALNAME="../platform2"
# iioservice/ is included just to make sandbox happy when running `gn gen`.
CROS_WORKON_SUBTREE=".gn camera/build camera/common camera/features camera/gpu camera/include camera/mojo chromeos-config common-mk iioservice/libiioservice_ipc iioservice/mojo metrics ml_core ml_core/mojo"
CROS_WORKON_OUTOFTREE_BUILD="1"
CROS_WORKON_INCREMENTAL_BUILD="1"

PLATFORM_SUBDIR="camera/common/sw_privacy_switch_test"

inherit cros-workon platform

DESCRIPTION="ChromeOS Camera SW privacy switch test"

LICENSE="BSD-Google"
KEYWORDS="*"

IUSE=""

BDEPEND="virtual/pkgconfig"

RDEPEND="
	chromeos-base/chromeos-config-tools:=
	chromeos-base/cros-camera-android-deps:=
	chromeos-base/cros-camera-libs:=
	chromeos-base/metrics:=
	dev-cpp/gtest:=
	media-libs/libyuv:=
"

DEPEND="
	${RDEPEND}
"

src_configure() {
	# This is necessary for CameraBufferManagerImpl::AllocateScopedBuffer to
	# succeed. Without this, gbm_bo_create will fail.
	cros_optimize_package_for_speed
	platform_src_configure
}
