# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5
CROS_WORKON_COMMIT="2dd3d106bd58a967dca1551808c11f269741d9b0"
CROS_WORKON_TREE=("101900c2b48b3a1e97069bd81150e6af6ff9e680" "2bf2ff83f660cb18f2ce734f7b8d1f2a0e93c236" "dc1506ef7c8cfd2c5ffd1809dac05596ec18773c")
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk cecservice .gn"

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
