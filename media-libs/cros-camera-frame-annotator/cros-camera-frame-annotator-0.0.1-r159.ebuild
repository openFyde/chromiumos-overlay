# Copyright 2022 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="cf08e4eb618a56e5963cf5e07f88bf3c6589a456"
CROS_WORKON_TREE=("f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6" "2ad8679ea3a8f3e8a2509b4b05585f22f2dc373b" "85a191405c05e42bfd25351a62cf7ea0d96f18a2" "40a1c83b03a8d998cc3846a40c3ee320d6c0129f" "1697e2a89338d2b3e96ef241123e271016f84682" "7010a5d9405cc702f23ac245cff1c1a7a877ad4e" "a0af00390c3d3c63903578edd1d7c7cb504a8699" "4a6e4c4f4458a2479859e637c02b0ae6deb9ea16" "6836462cc3ac7e9ff3ce4e355c68c389eb402bff" "7ddb8f962dd6611aef849f6a4c0ed7268cedb699" "6da0a978ba1edbe645822f82ddb2493d34ecf9f7" "beb84f969b87c56cfb4de8bb541063970eae8fa1" "1df96416290731160d582fa8ffa8f156b2fbac53")
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
