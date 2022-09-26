# Copyright 2022 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="26335906950b42940c1d2ac16d843711b570249d"
CROS_WORKON_TREE=("f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6" "3acfc95dd3569b0195030d53f6df21df011e12cd" "d802be56be4b508438c403083017eab1a996bce3" "3035153259a6317eb40f4676340d6ddae5139b23" "76841a45bb50e3e7b53d0f0ee1654d4c702eea1c" "d19e7560863f3e0d30d80ead3dcfb5fcd2b3eca1" "0459d2d800b5b9edfd24eec4c6fe63167d146835" "1ab6ce97d9eda19e26a20b996ecb2ed90361e01d" "9706471f3befaf4968d37632c5fd733272ed2ec9" "7ddb8f962dd6611aef849f6a4c0ed7268cedb699" "6da0a978ba1edbe645822f82ddb2493d34ecf9f7")
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_LOCALNAME="../platform2"
CROS_WORKON_SUBTREE=".gn camera/build camera/common camera/include camera/features camera/gpu camera/mojo chromeos-config common-mk iioservice/libiioservice_ipc iioservice/mojo"
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
