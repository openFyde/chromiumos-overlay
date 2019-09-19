# Copyright 2014 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=6

CROS_WORKON_COMMIT="916ae8655469e9ca4b66524a9d046483772b8864"
CROS_WORKON_TREE=("fc7fc7a30cc667a3d0fec5545fc6601b38b074ae" "53a0c3d1711d25e695191bfb5b0ea20fd9e69f37" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk peerd .gn"

PLATFORM_SUBDIR="peerd"

inherit cros-workon platform user

DESCRIPTION="Local peer discovery services for Chromium OS"
HOMEPAGE="http://www.chromium.org/"
LICENSE="BSD-Google"
SLOT=0
KEYWORDS="*"

RDEPEND="
	chromeos-base/libbrillo
	net-dns/avahi-daemon
"

DEPEND="${RDEPEND}"

pkg_preinst() {
	# Create user and group for peerd.
	enewuser "peerd"
	enewgroup "peerd"
}

src_install() {
	dobin "${OUT}/peerd"
	# Install init scripts.
	insinto /etc/init
	doins init/peerd.conf
	# Install DBus configuration files.
	insinto /etc/dbus-1/system.d
	doins dbus/org.chromium.peerd.conf
	# Install DBus client library.
	platform_install_dbus_client_lib
}

platform_pkg_test() {
	local tests=(
		peerd_testrunner
	)

	local test_bin
	for test_bin in "${tests[@]}"; do
		platform_test "run" "${OUT}/${test_bin}"
	done
}
