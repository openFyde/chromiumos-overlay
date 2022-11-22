# Copyright 2020 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="e19d8b91a762fa090fc300607dec61c3a9f5ea4a"
CROS_WORKON_TREE=("ebcce78502266e81f55c63ade8f25b8888e2c103" "32b04ffb59bdf712dd8f251f5e3d86b5bfa22dc8" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
CROS_WORKON_LOCALNAME="../platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_DESTDIR="${S}/platform2"
CROS_WORKON_SUBTREE="common-mk ml_core .gn"

DESCRIPTION="Chrome OS ML Core Feature Library"

PLATFORM_SUBDIR="ml_core"

inherit cros-workon platform

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE="internal local_ml_core_internal"

RDEPEND="
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

src_install() {
	platform_src_install
	dolib.so "${OUT}"/lib/libcros_ml_core.so
}
