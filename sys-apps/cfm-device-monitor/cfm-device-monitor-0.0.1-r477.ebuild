# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CROS_WORKON_COMMIT=("fc94ecedde9e1c06cd296bfb551295be651a1f66" "9ac7036a665c40e8a86213f21303ec329d039f07")
CROS_WORKON_TREE=("dee870e424cb9c2bf83477e685ba64450a5b16f3" "dc1506ef7c8cfd2c5ffd1809dac05596ec18773c" "70e668e8ed691137b59309faae32baa0028767fc")
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
