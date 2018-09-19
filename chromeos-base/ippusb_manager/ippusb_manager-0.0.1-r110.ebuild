# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5
CROS_WORKON_COMMIT="6ff57fa38a9d7ef01f2eef93680aa515f5fdba98"
CROS_WORKON_TREE=("db103a9dd2c79eed8075b58d7c1c4484354a1683" "e2a87253b8da75a2ee9bf92e197c7e8d7e5b2824" "dc1506ef7c8cfd2c5ffd1809dac05596ec18773c")
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk ippusb_manager .gn"

PLATFORM_SUBDIR="ippusb_manager"

inherit cros-workon platform udev user

DESCRIPTION="Service which manages communication between ippusbxd and cups."
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/ippusb_manager/"

LICENSE="BSD-Google"
SLOT=0
KEYWORDS="*"
IUSE=""

RDEPEND="
	chromeos-base/minijail
	chromeos-base/libbrillo
	net-print/ippusbxd
	virtual/libusb:1=
"

DEPEND="${RDEPEND}"

pkg_preinst() {
	enewgroup ippusb
	enewuser ippusb
}

platform_pkg_test() {
	platform_test "run" "${OUT}/ippusb_manager_testrunner"
}

src_install() {
	dobin "${OUT}"/ippusb_manager

	# udev rules.
	udev_dorules udev/*.rules

	# Install policy files.
	insinto /usr/share/policy
	newins seccomp/ippusb-manager-seccomp-${ARCH}.policy \
		ippusb-manager-seccomp.policy

	# Upstart script.
	insinto /etc/init
	doins etc/init/*.conf
}
