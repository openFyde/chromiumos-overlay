# Copyright 2022 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="c3021c98777b335e3b655156b15bb037aba7df02"
CROS_WORKON_TREE=("f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6" "4fc7c463ce102d1dff62e86baffad4a67ea2c940" "535ed81ea9213eb467e18bdb6358287248f4b75e" "3035153259a6317eb40f4676340d6ddae5139b23" "0235261499184305985b60183ac46986b0d28761" "4a86cdeef3d62cc86c76c7ec778bb1bff8949cae" "c4267a2954a2bd2b33146b612735c5aadf83725f" "d12ed295f53b887d40f4f039cd0a09bb07530877" "4b7854d72e018cacbb3455cf56f41cee31c70fc1" "7ddb8f962dd6611aef849f6a4c0ed7268cedb699" "6da0a978ba1edbe645822f82ddb2493d34ecf9f7" "a332d638a83bd89252a1f4db1bb5b334c05b968a" "66b54cea3851efbc3908ab5efed5d55370a6be52")
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
