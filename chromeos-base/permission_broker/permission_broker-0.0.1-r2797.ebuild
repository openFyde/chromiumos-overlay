# Copyright (c) 2012 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="4"

CROS_WORKON_COMMIT="0721e6874fe6fa422dc97c48224ab4c751afa0c8"
CROS_WORKON_TREE=("32c5802f3fce5f474cfae5f70fb058b1df68675f" "14720cecd44bc550a02c0b324f2f6b5922f86c73" "4cb95598c51ecaf2234abf080e04af7df6cd6905")
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
# TODO(crbug.com/809389): Avoid directly including headers from other packages.
CROS_WORKON_SUBTREE="common-mk container_utils permission_broker"

PLATFORM_NATIVE_TEST="yes"
PLATFORM_SUBDIR="${PN}"

inherit cros-workon platform udev user

DESCRIPTION="Permission Broker for Chromium OS"
HOMEPAGE="http://www.chromium.org/"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE="cfm_enabled_device containers"

RDEPEND="
	chromeos-base/libbrillo
	containers? ( chromeos-base/container_utils )
	sys-apps/dbus
	virtual/udev"

DEPEND="${RDEPEND}
	chromeos-base/system_api
	sys-kernel/linux-headers"

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
}

platform_pkg_test() {
	local tests=(
		permission_broker_unittest
	)

	local test_bin
	for test_bin in "${tests[@]}"; do
		platform_test "run" "${OUT}/${test_bin}"
	done
}

pkg_preinst() {
	enewuser "devbroker"
	enewgroup "devbroker"
	enewgroup "devbroker-access"
}
