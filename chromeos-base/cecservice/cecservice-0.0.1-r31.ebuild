# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5
CROS_WORKON_COMMIT="eee36c5192f4eaa2959f1b532c00d6d021b32c91"
CROS_WORKON_TREE=("45463f6780972e10b5979ed201843a5dd6e93b53" "75d6b33e0b5dafc02eac7d473a8de3cd8f492bde")
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk cecservice"

PLATFORM_SUBDIR="cecservice"

inherit cros-workon platform udev user

DESCRIPTION="Chrome OS CEC service"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/cecservice"
LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"

RDEPEND="
	chromeos-base/libbrillo
"
DEPEND="
	chromeos-base/system_api
	${RDEPEND}
"

pkg_preinst() {
	enewuser "cecservice"
	enewgroup "cecservice"
}

platform_pkg_test() {
	platform_test "run" "${OUT}/cecservice_testrunner"
}

src_install() {
	dosbin "${OUT}"/cecservice

	udev_dorules share/99-cec.rules

	# Install DBus config.
	insinto /etc/dbus-1/system.d
	doins share/org.chromium.CecService.conf

	# Install upstart script.
	insinto /etc/init
	doins share/cecservice.conf
}
