# Copyright 2021 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="5e015c51961dd6785f65516a350885927932e69a"
CROS_WORKON_TREE=("f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6" "2ad8679ea3a8f3e8a2509b4b05585f22f2dc373b" "1ea58e313616fd1f2d2a4ce39037869dfb136a1c" "2a732d74405761e6ffe5bcc97cbcd79de8741778" "f350915f69eba67849197cce3901bc104da7121a" "28e32d194b1e6c52d53446c04e8036414b2c8e12" "2ae3f5c18c4a966b50d7defcd4e5ecfc5d40d1d9" "d1531884133da981fe6414dbcd67713d10efeef7" "0f4044624c1fabe638a8289e62ec74756aa62176" "5be17ba0d331df49cda26486f5a3e5d5db8b480a" "6da0a978ba1edbe645822f82ddb2493d34ecf9f7" "e7b277c902521ebce99b342283d0aa3f9ce48ac0")
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_LOCALNAME="../platform2"
# iioservice/ is included just to make sandbox happy when running `gn gen`.
CROS_WORKON_SUBTREE=".gn camera/build camera/features camera/include camera/gpu camera/common camera/mojo chromeos-config common-mk iioservice/libiioservice_ipc iioservice/mojo ml_core ml_core/mojo"
CROS_WORKON_OUTOFTREE_BUILD="1"
CROS_WORKON_INCREMENTAL_BUILD="1"

PLATFORM_SUBDIR="camera/features/hdrnet/tests"

inherit cros-workon platform

DESCRIPTION="Chrome OS camera HDRnet integration tests"

LICENSE="BSD-Google"
KEYWORDS="*"

# 'ipu6' and 'ipu6ep' are passed to and used in BUILD.gn files.
IUSE="ipu6 ipu6ep"

BDEPEND="virtual/pkgconfig"

RDEPEND="
	chromeos-base/cros-camera-android-deps:=
	chromeos-base/cros-camera-libs:=
	dev-cpp/benchmark:=
	dev-cpp/gtest:=
	media-libs/cros-camera-libfs:=
	virtual/opengles:=
"

DEPEND="${RDEPEND}
	x11-drivers/opengles-headers:=
"

src_configure() {
	cros_optimize_package_for_speed
	platform_src_configure
}
