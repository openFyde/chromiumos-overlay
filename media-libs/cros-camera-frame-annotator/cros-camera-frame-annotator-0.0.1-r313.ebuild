# Copyright 2022 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="578002e99847450c1acf5fbdc217348022a7b6cb"
CROS_WORKON_TREE=("f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6" "6c6fe21162ea08ec90c2c7d7674913fa726d72af" "d6fd3b776e23a8c6357d764ac884d2d4059ee377" "a9a0ffa59bdd3d5f4dbcef883804d59c3b909b69" "98a486815aeea7ed5600111ab6f48ba6616caace" "56d11be3eee2e1ae4822f70f73b6e8cc7a4082c8" "5e629c67fd59365eaddcda399ebb829ff0360349" "258503e66813ac242d8f624f7ceb90743b402de7" "c5a3f846afdfb5f37be5520c63a756807a6b31c4" "1e601fb1df98e9ea9f5803aeb50bd6fbec835a2a" "e40ac435946a5417104d844a323350d04e9d3b2e" "cc439eaa02b1a03ca68f9de6ecf4a4df82029bc6")
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
