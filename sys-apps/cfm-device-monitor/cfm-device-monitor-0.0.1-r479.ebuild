# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CROS_WORKON_COMMIT=("c41e919212978240c7285a53d151557b889a9fc3" "b653c15b4954fd72ae1cd03c4ece428a1f4064ba")
CROS_WORKON_TREE=("ea6e2e1b6bec83695699ef78cec2f03321d97dd7" "dc1506ef7c8cfd2c5ffd1809dac05596ec18773c" "a3746e939e380126960395445240c8e9082a8f35")
inherit cros-constants

CROS_WORKON_INCREMENTAL_BUILD="1"
CROS_WORKON_PROJECT=("chromiumos/platform2" "chromiumos/platform/cfm-device-monitor")
CROS_WORKON_LOCALNAME=("../platform2" "../platform/cfm-device-monitor")
CROS_WORKON_DESTDIR=("${S}/platform2" "${S}/platform2/cfm-device-monitor")
CROS_WORKON_REPO=("${CROS_GIT_HOST_URL}" "${CROS_GIT_HOST_URL}")
CROS_WORKON_SUBTREE=("common-mk .gn" "")

PLATFORM_SUBDIR="cfm-device-monitor"

inherit cros-workon platform udev user

DESCRIPTION="A monitoring service that ensures liveness of cfm peripherals"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform/cfm-device-monitor"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE="fizz"

COMMON_DEPEND="
	chromeos-base/libbrillo
"
RDEPEND="
	${COMMON_DEPEND}
	chromeos-base/permission_broker
"
DEPEND="
	${COMMON_DEPEND}
	chromeos-base/system_api
"

src_install() {
	dosbin "${OUT}"/huddly-monitor
	dosbin "${OUT}"/mimo-monitor
	insinto "/etc/dbus-1/system.d"
	insinto "/etc/init"
	if use fizz ; then
		dosbin "${OUT}"/apex-monitor
		doins init/apex-monitor.conf
	fi
	doins init/huddly-monitor.conf
	doins init/mimo-monitor.conf
	udev_dorules conf/99-huddly-monitor.rules
	udev_dorules conf/99-mimo-monitor.rules
}

platform_pkg_test(){
	platform_test "run" "${OUT}/camera-monitor-test"
	platform_test "run" "${OUT}/apex-manager-test"
	platform_test "run" "${OUT}/apex-monitor-test"
}

pkg_preinst() {
	enewuser cfm-monitor
	enewgroup cfm-monitor
	enewgroup cfm-peripherals
}
