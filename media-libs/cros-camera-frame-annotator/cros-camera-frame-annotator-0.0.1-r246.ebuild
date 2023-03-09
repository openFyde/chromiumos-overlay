# Copyright 2022 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="24f4a28d2013633560cbeb7fd83489d42a9885a5"
CROS_WORKON_TREE=("f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6" "2ad8679ea3a8f3e8a2509b4b05585f22f2dc373b" "d3cdf6e1d3413a597340657946af477bcefb531d" "5736df8482a0c7b46de2d26dbb8be1680e8b7fbd" "a0f25272042c38e13d2dcd5990032f69aa830adc" "f350915f69eba67849197cce3901bc104da7121a" "2ae3f5c18c4a966b50d7defcd4e5ecfc5d40d1d9" "c938449e76217caf2e2b50666502efdd12fe98ca" "3f8a9a04e17758df936e248583cfb92fc484e24c" "5be17ba0d331df49cda26486f5a3e5d5db8b480a" "e40ac435946a5417104d844a323350d04e9d3b2e" "487c9debc972e47326f13a8aacbe606e28287a47")
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
