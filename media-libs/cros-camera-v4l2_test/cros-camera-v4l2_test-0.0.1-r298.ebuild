# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=6

CROS_WORKON_COMMIT="c0d2a7e597f69365b76774b9b56cdf8b291a28e3"
CROS_WORKON_TREE=("e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb" "c920da127f686c434165b6056b1cd740f228df6b" "0c5dd9314b371b69ea4c6552b948251370b301db" "85dcd31292e99125b2eb2744c83442e00dece79f" "df9cab6e50010dff80789ea9e26d127724f02a1b" "a74366253f104fe685e9cd7debd8f1a6e59b3c2c" "7d6de4299fef55d16dfedeb3723b1a312e0c9acd")
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
