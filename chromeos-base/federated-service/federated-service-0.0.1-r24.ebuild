# Copyright 2021 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="92b836aa7b1a8bcb55aef0e697120632481dd525"
CROS_WORKON_TREE=("d9c21c3b0f24d480773fdba553eb9db4ee252072" "95b1d136eb10f28311fc172aed9c190c315e665c" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
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
IUSE=""

#TODO(alanlxl): add federated_library
RDEPEND="
	dev-db/sqlite:=
	chromeos-base/session_manager-client:=
	chromeos-base/system_api:=
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
	dobin "${OUT}"/federated_service

	# Install upstart configuration.
	insinto /etc/init
	doins init/*.conf

	# Install seccomp policy file.
	insinto /usr/share/policy
	newins "seccomp/federated_service-seccomp-${ARCH}.policy" federated_service-seccomp.policy

	# Install D-Bus configuration file.
	insinto /etc/dbus-1/system.d
	doins dbus/org.chromium.Federated.conf

	# Install D-Bus service activation configuration.
	insinto /usr/share/dbus-1/system-services
	doins dbus/org.chromium.Federated.service

	# Storage path for examples, will be mounted as
	# /run/daemon-store/federated/<user_hash> after user logs in.
	local daemon_store="/etc/daemon-store/federated"
	dodir "${daemon_store}"
	fperms 0700 "${daemon_store}"
	fowners federated-service:federated-service "${daemon_store}"
}

platform_pkg_test() {
	platform_test "run" "${OUT}/federated_service_test"
}
