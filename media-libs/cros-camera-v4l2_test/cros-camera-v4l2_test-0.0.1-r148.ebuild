# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=6

CROS_WORKON_COMMIT="9ec82d23dcbf5139cfb79b70e79c3f1920763933"
CROS_WORKON_TREE=("e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb" "d58be6324ba2a1d0452d23bafb39c869c5ed2cd6" "c8e99be9d664ace542c2f1ecf0fe338d7c1f14a7" "49ebbb04271c8adf7488fdfb4c30b4a08c85a414" "593ea2129e1026e68f39ca4e36495aa530da2ace" "e76553bebb9315ff46405a1bd1045256117802c4")
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_LOCALNAME="../platform2"
CROS_WORKON_SUBTREE=".gn camera/build camera/common camera/include camera/v4l2_test common-mk"
CROS_WORKON_OUTOFTREE_BUILD="1"
CROS_WORKON_INCREMENTAL_BUILD="1"

PLATFORM_SUBDIR="camera/v4l2_test"

inherit cros-camera cros-workon platform

DESCRIPTION="Chrome OS camera V4L2 test."

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"

RDEPEND="
	chromeos-base/libbrillo:=
	dev-cpp/gtest:=
	dev-libs/re2:=
	media-libs/libyuv
	virtual/jpeg:0"

DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_install() {
	dobin "${OUT}/media_v4l2_is_capture_device"
	dobin "${OUT}/media_v4l2_test"
}
