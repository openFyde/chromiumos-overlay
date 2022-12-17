# Copyright 2022 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="569acd1eb0e5ee39f1e4b50921a0856c0b30f137"
CROS_WORKON_TREE=("0c3a30cd50ce72094fbd880f2d16d449139646a2" "81d41f213390c76faabca525e954955d49e3fe5e" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
CROS_WORKON_LOCALNAME="../platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_DESTDIR="${S}/platform2"
CROS_WORKON_SUBTREE="common-mk ml_core .gn"

DESCRIPTION="Tests for Chrome OS ML Core Feature Library"

PLATFORM_SUBDIR="ml_core/tests"

inherit cros-workon platform

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
