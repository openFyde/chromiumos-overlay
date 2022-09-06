# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CROS_WORKON_COMMIT="df89910a8318685886997f8deb915b842ad22403"
CROS_WORKON_TREE=("e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb" "ff65ca0654f4ad010db90044a858e246d3a70bdd" "5f258c56599853ebf5bc3490d32675fa156bd5c8" "dfca03ac1f2edbf642708af0992891cc93024aa8" "f063c143da4054868aadc5be54cc3a45415a698e")
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_LOCALNAME="../platform2"
CROS_WORKON_SUBTREE=".gn camera/build camera/common camera/include common-mk"
CROS_WORKON_OUTOFTREE_BUILD="1"
CROS_WORKON_INCREMENTAL_BUILD="1"

PLATFORM_SUBDIR="camera/common/jpeg/libjda_test"

inherit cros-camera cros-workon platform

DESCRIPTION="End to end test for JPEG decode accelerator"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"

RDEPEND="dev-cpp/gtest"

DEPEND="${RDEPEND}
	chromeos-base/cros-camera-libs"

src_install() {
	platform_src_install
	dobin "${OUT}/libjda_test"
}
