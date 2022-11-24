# Copyright 2020 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="a2f994c508897e7130a061a5472f97229f45c46b"
CROS_WORKON_TREE=("ebcce78502266e81f55c63ade8f25b8888e2c103" "5866489a03b2274fb8fb4ce86fb47de2c45f77e8" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
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

	insinto /etc/init
	doins opencl_caching/init/opencl-cacher.conf

	# For now, we run everything as the camera user,
	# so use "arc-camera"
	local daemon_store="/etc/daemon-store/ml-core-effects"
	dodir "${daemon_store}"
	fperms 0700 "${daemon_store}"
	fowners arc-camera:arc-camera "${daemon_store}"
}

platform_pkg_test() {
	platform test_all
}

pkg_setup() {
	# Has to be done in pkg_setup() instead of pkg_preinst() since
	# src_install() needs arc-camera.
	enewuser "arc-camera"
	enewgroup "arc-camera"
	cros-workon_pkg_setup
}
