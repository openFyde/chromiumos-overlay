# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CROS_WORKON_COMMIT=("87f0ac864472277e60b7f6c9f6ec895761c1e191" "24750a61211799ff0137ac16308b53347a68c78e")
CROS_WORKON_TREE=("6589055d0d41e7fc58d42616ba5075408d810f7d" "45af0449eba873048075d96cc2e24a5b6dbdc7c4" "7db7e0f493ad0b47165e64d5c78cf43c560326cc" "bae840cc6a5203050c6ab395cc3d0fbd74f603da" "34bcb6266df551e7744073b28ff1b6aa18023fe2")
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
