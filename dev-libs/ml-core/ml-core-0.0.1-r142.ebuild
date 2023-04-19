# Copyright 2020 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="3a8bad7d5ae3082031e6a20859cd37085d907336"
CROS_WORKON_TREE=("6350979dbc8b7aa70c83ad8a03dded778848025d" "c2ae901283e8bccc749553aaa986ddf56e1b4aa2" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
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

SRC_URI="gs://chromeos-localmirror/distfiles/ml-core-headers-20230419.tar.xz"

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
	if use local_ml_core_internal; then
		# Unpack local build.
		local dev_tarball="/mnt/google3_staging/ml-core-libcros_ml_core_internal-dev.tar.xz"
		echo "Checking for ${dev_tarball}"
		[[ ! -f "${dev_tarball}" ]] && die "Couldn't find ${dev_tarball} used by local_ml_core_internal. Did you run chromeos/ml/build_dev.sh in google3?"
		echo "Unpacking ${dev_tarball}"
		unpack "${dev_tarball}"
	else
		# Unpack SRC_URI
		unpacker
	fi
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
