# Copyright 2022 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="7b0ebba0e34deadfef168f423dd41639bf1082ba"
CROS_WORKON_TREE=("f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6" "67326aa19f1aee5051aefd50a959b82d12643540" "942e5bce2836cc95b4dc9b416d02e2fee3435359" "f23c8acad728eee832a0925c3bb48a04f3199fef" "56d11be3eee2e1ae4822f70f73b6e8cc7a4082c8" "a107bda06bdcf45088d2aecf0d50b69804adfd69" "4346f7da65df359f08635a2031a3e6b5036731c1" "ec2c9a2c5033b80cd1d5791abfa91eff20156237" "017dc03acde851b56f342d16fdc94a5f332ff42e" "1e601fb1df98e9ea9f5803aeb50bd6fbec835a2a" "e40ac435946a5417104d844a323350d04e9d3b2e" "e1f223c8511c80222f764c8768942936a8de01e4" "3b11fc6ac3a2ed2e40dfa6d862da597b72fd883d")
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
