# Copyright 2022 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="4025aab4f7da05fe2b8c37fd89a2943d4e72f794"
CROS_WORKON_TREE=("f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6" "67326aa19f1aee5051aefd50a959b82d12643540" "3ddaa6dd2fd388bc8c3dfcf10e359010158cdd37" "8382512685d679dd033d07c31295df8160820113" "62accd55112eaf950a16128a75eb7ae21468093a" "56d11be3eee2e1ae4822f70f73b6e8cc7a4082c8" "42d4c946578d8a8457ffbcc4ce9125341f8f42f1" "6aeb64d112325ba29ac82c4ca505fe329c1967e7" "8fad85aa9518e1a0f04272ae9e077c4a4036297d" "1e601fb1df98e9ea9f5803aeb50bd6fbec835a2a" "e40ac435946a5417104d844a323350d04e9d3b2e" "530aad55e0d4e774c14ac82608f49886f5de773e")
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
