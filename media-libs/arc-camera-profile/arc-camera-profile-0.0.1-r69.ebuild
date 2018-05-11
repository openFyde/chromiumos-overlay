# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CROS_WORKON_COMMIT=("07a3846a38c2225f1fb22742d56727d0d58e2a18" "aad546f2a06fd7cbc9f00c573d33f2e2a4402afb")
CROS_WORKON_TREE=("6589055d0d41e7fc58d42616ba5075408d810f7d" "8a5a9cc751cd7fff1b0ee77c1cf4f5d6d41cde2c" "0f93a06541157726fd56da5dc65eb9f25b19756e" "1c60697df0f10da379411bb7cbd79002f9714883" "ce18fba0c0aae39b3917fd9511c2a282b7fb703b")
CROS_WORKON_PROJECT=(
	"chromiumos/platform/arc-camera"
	"chromiumos/platform2"
)
CROS_WORKON_LOCALNAME=(
	"../platform/arc-camera"
	"../platform2"
)
CROS_WORKON_DESTDIR=(
	"${S}/platform/arc-camera"
	"${S}/platform2"
)
CROS_WORKON_SUBTREE=(
	"build hal/usb include tools"
	"common-mk"
)
PLATFORM_GYP_FILE="tools/generate_camera_profile.gyp"

inherit cros-camera cros-workon

DESCRIPTION="Runtime detect the number of cameras on device to generate
corresponding media_profiles.xml."

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"

RDEPEND="
	chromeos-base/libbrillo
	media-libs/cros-camera-libcamera_timezone"

DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_unpack() {
	cros-camera_src_unpack
}

src_install() {
	dobin "${OUT}/generate_camera_profile"
}
