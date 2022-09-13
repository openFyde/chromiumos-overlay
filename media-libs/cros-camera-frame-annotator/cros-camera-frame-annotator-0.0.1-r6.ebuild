# Copyright 2022 The ChromiumOS Authors.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="2b5d4476092a406f3dff84a68a7225bb345732ce"
CROS_WORKON_TREE=("f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6" "3acfc95dd3569b0195030d53f6df21df011e12cd" "96b809ab6edb3f1f648d6b034f9c8dc990a8364b" "197256e128dfbd415658f826d9844be61cd64e24" "4714a552c10718646c95beb770d666dfa8fbfd67" "7a2b28cbf8a0a2ae2deb42fb07cee21118708567" "0459d2d800b5b9edfd24eec4c6fe63167d146835" "8e4d5a3fd9bdb03a6a2d9070f2f3db65b5dd8479" "52639708fb7bf1a26ac114df488dc561a7ca9f3c" "6da0a978ba1edbe645822f82ddb2493d34ecf9f7")
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_LOCALNAME="../platform2"
CROS_WORKON_SUBTREE=".gn camera/build camera/common camera/include camera/features camera/gpu camera/mojo chromeos-config common-mk iioservice/mojo"
CROS_WORKON_OUTOFTREE_BUILD="1"
CROS_WORKON_INCREMENTAL_BUILD="1"

PLATFORM_SUBDIR="camera/features/frame_annotator/libs"

inherit cros-workon platform

DESCRIPTION="ChromeOS Camera Frame Annotator Library"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"

BDEPEND="virtual/pkgconfig"

RDEPEND="
	media-libs/skia:=
	chromeos-base/cros-camera-libs:=
"
DEPEND="
	${RDEPEND}
"

src_configure() {
	cros_optimize_package_for_speed
	platform_src_configure
}

src_install() {
	platform_src_install

	dolib.so "${OUT}"/lib/libcros_camera_frame_annotator.so
}
