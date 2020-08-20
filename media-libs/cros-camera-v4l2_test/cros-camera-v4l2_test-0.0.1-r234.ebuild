# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=6

CROS_WORKON_COMMIT="4aaa540eb141fbec54f7a1b3536e3741cb0c0b9c"
CROS_WORKON_TREE=("e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb" "d58be6324ba2a1d0452d23bafb39c869c5ed2cd6" "02c35a0fc1c4c297a20fc871604f645473919103" "d6fa10cef5a85a2615e1273240c221a553b43cc3" "10ba1d154dfad81e9edcabd542703c914aace1a9" "33d018aec398b4ca1124df857db8f89394d141be" "85e4e098023fcccb8851b45c351a7045fa23f06f")
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_LOCALNAME="../platform2"
CROS_WORKON_SUBTREE=".gn camera/build camera/common camera/include camera/v4l2_test chromeos-config common-mk"
CROS_WORKON_OUTOFTREE_BUILD="1"
CROS_WORKON_INCREMENTAL_BUILD="1"

PLATFORM_SUBDIR="camera/v4l2_test"

inherit cros-camera cros-workon platform

DESCRIPTION="Chrome OS camera V4L2 test."

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE="generated_cros_config unibuild"

RDEPEND="
	chromeos-base/chromeos-config-tools
	chromeos-base/libbrillo:=
	dev-cpp/gtest:=
	dev-libs/re2:=
	media-libs/libyuv
	unibuild? (
		!generated_cros_config? ( chromeos-base/chromeos-config )
		generated_cros_config? ( chromeos-base/chromeos-config-bsp )
	)
	virtual/jpeg:0"

DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_install() {
	dobin "${OUT}/media_v4l2_is_capture_device"
	dobin "${OUT}/media_v4l2_test"
}
