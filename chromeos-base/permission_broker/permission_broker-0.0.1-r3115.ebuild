# Copyright (c) 2012 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="5f03ce3f3c6b0d190484354cce47934ced7c22ed"
CROS_WORKON_TREE=("eaed4f3b0a8201ef3951bf1960728885ff99e772" "6b1653a8bc11763f4edfa645e1f1464b4bee4fd2" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk permission_broker .gn"

PLATFORM_NATIVE_TEST="yes"
PLATFORM_SUBDIR="${PN}"

inherit cros-workon platform udev user

DESCRIPTION="Permission Broker for Chromium OS"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/permission_broker/"

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE="cfm_enabled_device fuzzer"

COMMMON_DEPEND="
	chromeos-base/patchpanel-client:=
	sys-apps/dbus:=
	virtual/libusb:1
	virtual/udev
"

RDEPEND="${COMMMON_DEPEND}"
DEPEND="${COMMMON_DEPEND}
	chromeos-base/system_api:=[fuzzer?]
	sys-kernel/linux-headers:=
"

src_install() {
	dobin "${OUT}"/permission_broker

	# Install upstart configuration
	insinto /etc/init
	doins permission_broker.conf

	# DBus configuration
	insinto /etc/dbus-1/system.d
	doins dbus/org.chromium.PermissionBroker.conf

	# Udev rules for hidraw nodes
	udev_dorules "${FILESDIR}/99-hidraw.rules"

	# Fuzzer.
	platform_fuzzer_install "${S}"/OWNERS "${OUT}"/port_tracker_fuzzer
}

platform_pkg_test() {
	local tests=(
		permission_broker_test
	)

	local test_bin
	for test_bin in "${tests[@]}"; do
		platform_test "run" "${OUT}/${test_bin}"
	done
}

pkg_preinst() {
	enewuser "devbroker"
	enewgroup "devbroker"
}
