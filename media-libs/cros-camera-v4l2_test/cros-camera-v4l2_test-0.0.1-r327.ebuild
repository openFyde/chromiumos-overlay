# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=6

CROS_WORKON_COMMIT="b05e4a6b92b2cfe608b6cd8d5d37168680fc080e"
CROS_WORKON_TREE=("e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb" "c920da127f686c434165b6056b1cd740f228df6b" "da7b73732df1f454a05ffc3efe5a90d416295e3f" "4a915605af1cd7e632f8e36813007c5403431db2" "33af14dee8d39c8e5b1ab60b776257b3dd3169f7" "316f9280ff87203d961bd29b773e08824f1c45d4" "52a8a8b6d3bbca5e90d4761aa308a5541d52b1bb")
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_LOCALNAME="../platform2"
CROS_WORKON_SUBTREE=".gn camera/build camera/common camera/include camera/hal/usb chromeos-config common-mk"
CROS_WORKON_OUTOFTREE_BUILD="1"
CROS_WORKON_INCREMENTAL_BUILD="1"

PLATFORM_SUBDIR="camera/hal/usb/v4l2_test"

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
	platform_src_install
	dobin "${OUT}/media_v4l2_is_capture_device"
	dobin "${OUT}/media_v4l2_test"
}
