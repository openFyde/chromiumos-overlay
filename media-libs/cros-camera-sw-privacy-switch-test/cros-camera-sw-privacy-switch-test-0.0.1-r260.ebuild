# Copyright 2022 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="b21e22f16afa196b25fdd455fc66861d872fa2d3"
CROS_WORKON_TREE=("f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6" "2ad8679ea3a8f3e8a2509b4b05585f22f2dc373b" "d3cdf6e1d3413a597340657946af477bcefb531d" "9cb6d2ed7e46c29dc84445bbf434dd58fb0fc69a" "f350915f69eba67849197cce3901bc104da7121a" "14f00dcafbef98a768f7f7be17cb697ac12dc529" "2ae3f5c18c4a966b50d7defcd4e5ecfc5d40d1d9" "c938449e76217caf2e2b50666502efdd12fe98ca" "3f8a9a04e17758df936e248583cfb92fc484e24c" "5be17ba0d331df49cda26486f5a3e5d5db8b480a" "e40ac435946a5417104d844a323350d04e9d3b2e" "e1f223c8511c80222f764c8768942936a8de01e4" "487c9debc972e47326f13a8aacbe606e28287a47")
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
