# Copyright 2020 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="8e9fd20b06b0426522bb3d863849e1bb707d08b3"
CROS_WORKON_TREE=("3f8a9a04e17758df936e248583cfb92fc484e24c" "fb6368da756315dca470a76956c457fb2a606b6e" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
CROS_WORKON_LOCALNAME="../platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_DESTDIR="${S}/platform2"
CROS_WORKON_SUBTREE="common-mk ml_core .gn"

DESCRIPTION="Chrome OS ML Core Feature Library"

PLATFORM_SUBDIR="ml_core"

inherit cros-workon platform user unpacker

LICENSE="BSD-Google"
KEYWORDS="*"

# camera_feature_effects needed as `use.camera_feature_effects` is
# referenced in BUILD.gn
IUSE="internal local_ml_core_internal camera_feature_effects"

SRC_URI="gs://chromeos-localmirror/distfiles/ml-core-headers-20230313.tar.xz"

RDEPEND="
	chromeos-base/dlcservice-client:=
	chromeos-base/session_manager-client:=
	internal? ( chromeos-base/ml-core-internal:= )
"
DEPEND="${RDEPEND}
"

src_unpack() {
	platform_src_unpack

	# Unpack the headers into the srcdir
	pushd "${S}" > /dev/null || die
	unpacker
	popd > /dev/null || die
}

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
