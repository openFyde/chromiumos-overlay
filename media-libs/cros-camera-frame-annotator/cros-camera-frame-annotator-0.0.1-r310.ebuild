# Copyright 2022 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="7660c2e3ace18f4d6d50149b003118d6fb1c74fe"
CROS_WORKON_TREE=("f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6" "6a208d3bace261bf98c78f08d147fe0e348a362d" "db263a10cec3fc724e82e1f6615e51abad77eae7" "a9a0ffa59bdd3d5f4dbcef883804d59c3b909b69" "964ef2d3cec6990d08322f30c3ba818723271eec" "56d11be3eee2e1ae4822f70f73b6e8cc7a4082c8" "42d4c946578d8a8457ffbcc4ce9125341f8f42f1" "258503e66813ac242d8f624f7ceb90743b402de7" "b22d37072ba4d5aec5ad10140a826f42281ddd3e" "1e601fb1df98e9ea9f5803aeb50bd6fbec835a2a" "e40ac435946a5417104d844a323350d04e9d3b2e" "cc439eaa02b1a03ca68f9de6ecf4a4df82029bc6")
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_LOCALNAME="../platform2"
CROS_WORKON_SUBTREE=".gn camera/build camera/common camera/include camera/features camera/gpu camera/mojo chromeos-config common-mk iioservice/libiioservice_ipc iioservice/mojo ml_core"
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
	media-libs/libyuv:=
	media-libs/skia:=
	chromeos-base/metrics:=
	chromeos-base/cros-camera-libs:=
"
DEPEND="
	x11-drivers/opengles-headers:=
	${RDEPEND}
"

src_configure() {
	cros_optimize_package_for_speed
	platform_src_configure
}
