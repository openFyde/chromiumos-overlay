# Copyright 2022 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="c6df4ad90adf6e8cd06b3d3de584aaa306fb7f3c"
CROS_WORKON_TREE=("f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6" "3a939e262dbbb04bab2434b9e34a18e1f4cbda60" "2c9070a9ea781b3bff42d2063f1bedf26f19335e" "0b0dd5bc473351b6560e9918ec0b086342282058" "6859f2bbfde351b8ea73fd3364b643806d7cd14d" "a9a69ecbf7bea295e96aa24cfb57d74046935663" "a0af00390c3d3c63903578edd1d7c7cb504a8699" "5c3bb2fd2ed1b07b2afc032368304988b7b7df99" "0c4b88db0ba1152616515efb0c6660853232e8d0" "7ddb8f962dd6611aef849f6a4c0ed7268cedb699" "6da0a978ba1edbe645822f82ddb2493d34ecf9f7" "5866489a03b2274fb8fb4ce86fb47de2c45f77e8" "1df96416290731160d582fa8ffa8f156b2fbac53")
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
