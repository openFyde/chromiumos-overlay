# Copyright 2020 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="cfaed8ee0686d82593a587f059077a01ba52cd19"
CROS_WORKON_TREE=("6836462cc3ac7e9ff3ce4e355c68c389eb402bff" "14df0f25e76b1a7ca05b8aa634e5b209e1cd201a" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
CROS_WORKON_LOCALNAME="../platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_DESTDIR="${S}/platform2"
CROS_WORKON_SUBTREE="common-mk ml_core .gn"

DESCRIPTION="Chrome OS ML Core Feature Library"

PLATFORM_SUBDIR="ml_core"

inherit cros-workon platform user

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE="internal local_ml_core_internal"

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

src_install() {
	platform_src_install
	dolib.so "${OUT}"/lib/libcros_ml_core.so

	# TODO (b/263434835): re-enable once we're sure this doesn't
	#                     interfere with the cros-camera service
	#                     downloading DLC
	# insinto /etc/init
	# doins opencl_caching/init/opencl-cacher.conf

	# # Only on AMD64 for now
	# insinto /usr/share/policy
	# doins opencl_caching/seccomp_filter/opencl-cacher-amd64.policy

	# insinto /etc/dbus-1/system.d
	# doins opencl_caching/dbus/opencl-cacher-dbus.conf

	local daemon_store="/etc/daemon-store/ml-core-effects"
	dodir "${daemon_store}"
	fperms 0770 "${daemon_store}"
	fowners ml-core:ml-core "${daemon_store}"
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
