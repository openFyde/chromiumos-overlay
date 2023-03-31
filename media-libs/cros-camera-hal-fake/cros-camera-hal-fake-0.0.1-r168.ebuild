# Copyright 2022 The ChromiumOS Authors.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="e364b159e56f23ece2af994214187c650908d14f"
CROS_WORKON_TREE=("f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6" "67326aa19f1aee5051aefd50a959b82d12643540" "06a2fbf765ecfda3b733c3d1af5c13d6a6ff6519" "6691dc6fa8154a6f5b243558f4915b1e8d0e2bdb" "5173d4b89e762b0b8012bdf26edff3b6de7eeda3" "2c1654d2485bf7fd97544265dc582a0c396bd4dc" "04da1711dfcf3e15f8ffb8bc59e4fc277481515b")
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
