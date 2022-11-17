# Copyright 2022 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="cabaaf3463b91aa8a977c889d325b1b25daac030"
CROS_WORKON_TREE=("f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6" "3a939e262dbbb04bab2434b9e34a18e1f4cbda60" "638bb471487099f00a4cfdb5245dedb07f9c501f" "aaef5d5dd5a995d20e5b04eab1d9142563ee9829" "1d82496c9809ba0d30d0f5bb0d2ebad6b0cff967" "a9a69ecbf7bea295e96aa24cfb57d74046935663" "0336dfaec1d10434d368801e929ad2b4d87e5f6c" "d091b647aee45fef875fef1dfdd69b1dd7123cbf" "ebcce78502266e81f55c63ade8f25b8888e2c103" "7ddb8f962dd6611aef849f6a4c0ed7268cedb699" "6da0a978ba1edbe645822f82ddb2493d34ecf9f7" "cadad2092ee8a0aac2fd53985e66461ccddcb80f" "22ed84b6e53a60ef2db1dd92057fe643463c35bd")
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_LOCALNAME="../platform2"
CROS_WORKON_SUBTREE=".gn camera/build camera/common camera/include camera/features camera/gpu camera/mojo chromeos-config common-mk iioservice/libiioservice_ipc iioservice/mojo ml_core ml_core/mojo"
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
