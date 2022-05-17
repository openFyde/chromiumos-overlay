# Copyright (c) 2012 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="d9beddc36d4a8f850dc2aeb7f233ef94319ef9aa"
CROS_WORKON_TREE=("de59adbdd65f19155026e185bb22dfe33dc9e80d" "e55781cd73929ed486f16fa1f72061557d6c1b36" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk permission_broker .gn"

PLATFORM_NATIVE_TEST="yes"
PLATFORM_SUBDIR="${PN}"

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
