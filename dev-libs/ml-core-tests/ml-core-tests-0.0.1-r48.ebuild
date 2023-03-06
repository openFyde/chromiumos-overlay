# Copyright 2022 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="659dad73fb1c3e976dbbfe65d467746c09165560"
CROS_WORKON_TREE=("3f8a9a04e17758df936e248583cfb92fc484e24c" "5778055c3054a5203232d45d57ad1aa81577d6dd" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
CROS_WORKON_LOCALNAME="../platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_DESTDIR="${S}/platform2"
CROS_WORKON_SUBTREE="common-mk ml_core .gn"

DESCRIPTION="Tests for Chrome OS ML Core Feature Library"

PLATFORM_SUBDIR="ml_core/tests"

inherit cros-workon platform

# camera_feature_effects needed as `use.camera_feature_effects` is
# referenced in BUILD.gn
IUSE="camera_feature_effects"
LICENSE="BSD-Google"
KEYWORDS="*"

RDEPEND="
	dev-libs/ml-core:=
	media-libs/libpng:=
	chromeos-base/dlcservice:=
	chromeos-base/dlcservice-client:=
"

DEPEND="${RDEPEND}
"

src_install() {
	platform_src_install

	insinto /usr/local/
	dobin "${OUT}"/ml_core_effects_pipeline_test

	insinto /usr/local/share/ml_core
	doins -r testdata/*.png
}

platform_pkg_test() {
	local tests=(
		ml_core_pngio_test
	)
	local test_bin
	for test_bin in "${tests[@]}"; do
		platform_test "run" "${OUT}/${test_bin}"
	done
}
