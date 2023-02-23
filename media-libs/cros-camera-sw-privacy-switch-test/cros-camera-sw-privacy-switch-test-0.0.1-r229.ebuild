# Copyright 2022 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="692b4a19c40ea683a597d7ecb711b26a24a1439c"
CROS_WORKON_TREE=("f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6" "2ad8679ea3a8f3e8a2509b4b05585f22f2dc373b" "5c1e7c1e15f7cbbb6d3966714c030b7ed2ab5f8f" "cef2916016bb5de48b768865930d6cdb92fa3dbb" "fda2d0c3096e3691b413cfb9cf7e3c1238d38856" "8e57c159340e360878b780d73ea9e75c72476f3b" "546d612834bb46518d8ed157a8923c49016e2fb5" "05fc07a8e14dcd189662efc576ac02ebef174e60" "92a7718bfe5a15c594fcc6b0855e68b0981cd9a0" "5be17ba0d331df49cda26486f5a3e5d5db8b480a" "6da0a978ba1edbe645822f82ddb2493d34ecf9f7" "e1f223c8511c80222f764c8768942936a8de01e4" "23cfffa30acecea70e6943db00f0f48222d8412b" "1df96416290731160d582fa8ffa8f156b2fbac53")
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_LOCALNAME="../platform2"
# iioservice/ is included just to make sandbox happy when running `gn gen`.
CROS_WORKON_SUBTREE=".gn camera/build camera/common camera/features camera/gpu camera/include camera/mojo chromeos-config common-mk iioservice/libiioservice_ipc iioservice/mojo metrics ml_core ml_core/mojo"
CROS_WORKON_OUTOFTREE_BUILD="1"
CROS_WORKON_INCREMENTAL_BUILD="1"

PLATFORM_SUBDIR="camera/common/sw_privacy_switch_test"

inherit cros-workon platform

DESCRIPTION="ChromeOS Camera SW privacy switch test"

LICENSE="BSD-Google"
KEYWORDS="*"

IUSE=""

BDEPEND="virtual/pkgconfig"

RDEPEND="
	chromeos-base/chromeos-config-tools:=
	chromeos-base/cros-camera-android-deps:=
	chromeos-base/cros-camera-libs:=
	chromeos-base/metrics:=
	dev-cpp/gtest:=
	media-libs/libyuv:=
"

DEPEND="
	${RDEPEND}
"

src_configure() {
	# This is necessary for CameraBufferManagerImpl::AllocateScopedBuffer to
	# succeed. Without this, gbm_bo_create will fail.
	cros_optimize_package_for_speed
	platform_src_configure
}
