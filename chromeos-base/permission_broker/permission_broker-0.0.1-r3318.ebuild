# Copyright 2012 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="930be51bd30c824049317fffdf6b0c03bd014c6a"
CROS_WORKON_TREE=("bb46f20bc6d2f9e7fb1aa1178d1e47384440de9a" "8dd7adab69e0446f2ef044a0df6de56c7539c1af" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk permission_broker .gn"

PLATFORM_NATIVE_TEST="yes"
PLATFORM_SUBDIR="permission_broker"

inherit cros-workon platform udev user

DESCRIPTION="Permission Broker for Chromium OS"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/permission_broker/"

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
	platform_src_install

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
	local fuzzer_component_id="156085"
	platform_fuzzer_install "${S}"/OWNERS "${OUT}"/port_tracker_fuzzer \
		--comp "${fuzzer_component_id}"
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
