# Copyright 2020 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="5e015c51961dd6785f65516a350885927932e69a"
CROS_WORKON_TREE=("0f4044624c1fabe638a8289e62ec74756aa62176" "e7b277c902521ebce99b342283d0aa3f9ce48ac0" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
CROS_WORKON_LOCALNAME="../platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_DESTDIR="${S}/platform2"
CROS_WORKON_SUBTREE="common-mk ml_core .gn"

DESCRIPTION="Chrome OS ML Core Feature Library"

PLATFORM_SUBDIR="ml_core"

inherit cros-workon platform user

LICENSE="BSD-Google"
KEYWORDS="*"

# camera_feature_effects needed as `use.camera_feature_effects` is
# referenced in BUILD.gn
IUSE="internal local_ml_core_internal camera_feature_effects"

RDEPEND="
	chromeos-base/dlcservice-client:=
	internal? ( chromeos-base/ml-core-internal:= )
"
DEPEND="${RDEPEND}
"

src_configure() {
	if use local_ml_core_internal; then
		append-cppflags "-DUSE_LOCAL_ML_CORE_INTERNAL"
	fi
	platform_src_configure
}

platform_pkg_test() {
	platform test_all
}

pkg_setup() {
	# Has to be done in pkg_setup() instead of pkg_preinst() since
	# src_install() needs ml-core.
	enewuser "ml-core"
	enewgroup "ml-core"
	cros-workon_pkg_setup
}
