# Copyright 2021 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="85b14a06205ad4309c718357829421bc4706d018"
CROS_WORKON_TREE=("f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6" "4fc7c463ce102d1dff62e86baffad4a67ea2c940" "198988eec7626cf6bbc6ddc06f3ebf71182dba28" "4b7854d72e018cacbb3455cf56f41cee31c70fc1")
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_LOCALNAME="../platform2"
CROS_WORKON_SUBTREE=".gn camera/build camera/features/document_scanning common-mk"
CROS_WORKON_OUTOFTREE_BUILD="1"
CROS_WORKON_INCREMENTAL_BUILD="1"

PLATFORM_SUBDIR="camera/features/document_scanning"

inherit cros-workon platform

DESCRIPTION="Chrome OS camera Document Scanning test."

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"

RDEPEND="
	chromeos-base/libbrillo:=
	dev-cpp/gtest:=
	media-libs/cros-camera-libfs:="

DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_install() {
	platform_src_install
	dobin "${OUT}/document_scanner_perf_test"
}
