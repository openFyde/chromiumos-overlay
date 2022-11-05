# Copyright 2022 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="ad6dbc1a7b79a01dba340fdaef6ffdf765f651c2"
CROS_WORKON_TREE=("f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6" "3a939e262dbbb04bab2434b9e34a18e1f4cbda60" "45141f034984704bc62e00096f2b4dfc00fb531d" "ea9fa272e68eab61f9328041f16682f8682ff0f2" "6d5226d2a684da9b501985bba340f52a119f5355" "4a86cdeef3d62cc86c76c7ec778bb1bff8949cae" "0336dfaec1d10434d368801e929ad2b4d87e5f6c" "a7a7808116af8df8b0b16f13e2544c3657af04e5" "949c73de3faed1daba26b0dcf53a03f571b02837" "7ddb8f962dd6611aef849f6a4c0ed7268cedb699" "6da0a978ba1edbe645822f82ddb2493d34ecf9f7" "d74dfbd2645bd12f42361103eff1cf98a56d6efd" "22ed84b6e53a60ef2db1dd92057fe643463c35bd")
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
