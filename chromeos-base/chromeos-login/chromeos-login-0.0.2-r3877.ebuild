# Copyright (c) 2012 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CROS_WORKON_COMMIT="cf65e45c51a11ebd14f39daf0be997f5a0fd90ba"
CROS_WORKON_TREE=("9a76761fb376cc658f8589352df93fec6d285267" "4281fd9d9a56ab784600670eff2475ee5248253a" "4c79364d27e4e358674a4f7e526cae268da3ff62" "7e36566109b9f0bcaa65fd383239b3a2b7cc2e0b" "d53dd2fc856c66eaf4ff54b66d667e051da2db79" "08cf31722fdac78c1ce293933fff54dd7b8a4728" "dc1506ef7c8cfd2c5ffd1809dac05596ec18773c")
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
# TODO(crbug.com/809389): Avoid directly including headers from other packages.
CROS_WORKON_SUBTREE="common-mk chromeos-config libcontainer libpasswordprovider login_manager metrics .gn"

PLATFORM_SUBDIR="login_manager"

inherit cros-workon platform systemd user

DESCRIPTION="Login manager for Chromium OS."
HOMEPAGE="http://www.chromium.org/"
SRC_URI=""

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE="cheets systemd unibuild"

RDEPEND="chromeos-base/bootstat
	unibuild? ( chromeos-base/chromeos-config )
	chromeos-base/chromeos-config-tools
	chromeos-base/minijail
	chromeos-base/cryptohome
	chromeos-base/libbrillo
	chromeos-base/libchromeos-ui
	chromeos-base/libcontainer
	chromeos-base/libpasswordprovider
	chromeos-base/metrics
	dev-libs/nss
	dev-libs/protobuf
	sys-apps/util-linux"

DEPEND="${RDEPEND}
	chromeos-base/protofiles
	chromeos-base/system_api
	chromeos-base/vboot_reference"

pkg_preinst() {
	enewgroup policy-readers
}

platform_pkg_test() {
	local tests=( session_manager_test )

	# Qemu doesn't support signalfd currently, and it's not clear how
	# feasible it is to implement :(.
	# So, filter out the tests that rely on signalfd().
	local gtest_qemu_filter=""
	if ! use x86 && ! use amd64; then
		gtest_qemu_filter+="-ChildExitHandlerTest.*"
		gtest_qemu_filter+=":SessionManagerProcessTest.*"
	fi



	local test_bin
	for test_bin in "${tests[@]}"; do
		platform_test "run" "${OUT}/${test_bin}" "0" "" "${gtest_qemu_filter}"
	done
}

src_install() {
	into /
	dosbin "${OUT}/keygen"
	dosbin "${OUT}/session_manager"

	# Install DBus configuration.
	insinto /usr/share/dbus-1/interfaces
	doins dbus_bindings/org.chromium.SessionManagerInterface.xml

	insinto /etc/dbus-1/system.d
	doins SessionManager.conf

	# Adding init scripts
	if use systemd; then
		systemd_dounit init/systemd/*
		systemd_enable_service x-started.target
		systemd_enable_service multi-user.target ui.target
		systemd_enable_service ui.target ui.service
		systemd_enable_service ui.service machine-info.service
		systemd_enable_service login-prompt-visible.target send-uptime-metrics.service
		systemd_enable_service login-prompt-visible.target ui-init-late.service
		systemd_enable_service start-user-session.target login.service
		systemd_enable_service system-services.target ui-collect-machine-info.service
	else
		insinto /etc/init
		doins init/upstart/*.conf
	fi
	exeinto /usr/share/cros/init/
	doexe init/scripts/*

	# For user session processes.
	dodir /etc/skel/log

	# For user NSS database
	diropts -m0700
	# Need to dodir each directory in order to get the opts right.
	dodir /etc/skel/.pki
	dodir /etc/skel/.pki/nssdb
	# Yes, the created (empty) DB does work on ARM, x86 and x86_64.
	certutil -N -d "sql:${D}/etc/skel/.pki/nssdb" -f <(echo '') || die

	insinto /etc
	doins chrome_dev.conf
}
