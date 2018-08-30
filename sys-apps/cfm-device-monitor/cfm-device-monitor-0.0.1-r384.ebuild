# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CROS_WORKON_COMMIT=("ca18b84d7b295fa48f6dcbebfbbda336bb8f5dc1" "881ed1ac9a234b9700c309b0a1f1a86e2b1f48a8")
CROS_WORKON_TREE=("0a0fbef74ac40dc525a95f9339687c591f6a8534" "4674d903b3fb2e2d10983ff339c948075527bde2")
inherit cros-constants

CROS_WORKON_INCREMENTAL_BUILD="1"
CROS_WORKON_PROJECT=("chromiumos/platform2" "chromiumos/platform/cfm-device-monitor")
CROS_WORKON_LOCALNAME=("../platform2" "../platform/cfm-device-monitor")
CROS_WORKON_DESTDIR=("${S}/platform2" "${S}/platform/cfm-device-monitor")
CROS_WORKON_REPO=("${CROS_GIT_HOST_URL}" "${CROS_GIT_HOST_URL}")
CROS_WORKON_SUBTREE=("common-mk" "")

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

src_unpack() {
	local s="${S}"
	platform_src_unpack
	S="${s}/platform/cfm-device-monitor"
}

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
