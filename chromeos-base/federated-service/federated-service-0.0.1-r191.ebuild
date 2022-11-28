# Copyright 2021 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="8f5e2ee4025e182b99c5e6181a0a2fe31239c14c"
CROS_WORKON_TREE=("7c7d4170b01f9cd05a107c251a378c716ccd9d77" "368e8e3b41e13bde41e9c5dd95b675810f51b982" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_DESTDIR="${S}/platform2"
CROS_WORKON_SUBTREE="common-mk federated .gn"

PLATFORM_SUBDIR="federated"

inherit cros-workon platform user

DESCRIPTION="Federated Computation service for Chromium OS"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/federated"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE="local-federated-server"

RDEPEND="
	dev-db/sqlite:=
	chromeos-base/dlcservice-client:=
	chromeos-base/metrics:=
	chromeos-base/session_manager-client:=
	chromeos-base/shill-dbus-client:=
	chromeos-base/system_api:=
	sys-cluster/fcp:=
"

DEPEND="
	${RDEPEND}
"

pkg_setup() {
	# Has to be done in pkg_setup() instead of pkg_preinst() since
	# src_install() needs the federated-service user and group.
	enewuser "federated-service"
	enewgroup "federated-service"
	cros-workon_pkg_setup
}

src_install() {
	platform_src_install

	# Storage path for examples, will be mounted as
	# /run/daemon-store/federated/<user_hash> after user logs in.
	local daemon_store="/etc/daemon-store/federated"
	dodir "${daemon_store}"
	fperms 0700 "${daemon_store}"
	fowners federated-service:federated-service "${daemon_store}"
}

platform_pkg_test() {
	platform test_all
}
