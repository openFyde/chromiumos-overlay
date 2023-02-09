# Copyright 2022 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="2659f620c407ec5aded18892b8b573db1962c3b8"
CROS_WORKON_TREE=("f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6" "2ad8679ea3a8f3e8a2509b4b05585f22f2dc373b" "7d2ae031147e89889a1f9a85c69bd597fe8b04d2" "8e57c159340e360878b780d73ea9e75c72476f3b" "cef2916016bb5de48b768865930d6cdb92fa3dbb" "7f33489067f631fadbf2083ac7f426bb1a051967" "546d612834bb46518d8ed157a8923c49016e2fb5" "fd2031f3c7dd64a1ca5f16ac2b2b9e52619c561c" "aaaaa3f7d8b4455b36eba6a9874fca10fefb836c" "5be17ba0d331df49cda26486f5a3e5d5db8b480a" "6da0a978ba1edbe645822f82ddb2493d34ecf9f7" "10d204972635f039764dae590a6f4756dcaeb5c4" "1df96416290731160d582fa8ffa8f156b2fbac53")
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
