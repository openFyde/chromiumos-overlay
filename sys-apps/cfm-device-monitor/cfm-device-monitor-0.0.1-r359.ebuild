# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CROS_WORKON_COMMIT=("3b35acc913a3b11c7ecf2e3c746fe3d6223c291b" "8e6c28caa1ab93e3efea4fe81ae03c29cd37b870")
CROS_WORKON_TREE=("85db6764c18b2cd6e849d2c5e5cd3138c23f3563" "50faf1a292126948524bc839ee8568f04d1b4bd1")
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
	doins init/huddly-monitor.conf
	doins init/mimo-monitor.conf
	udev_dorules conf/99-huddly-monitor.rules
	udev_dorules conf/99-mimo-monitor.rules
}

platform_pkg_test(){
	platform_test "run" "${OUT}/camera-monitor-test"
}

pkg_preinst() {
	enewuser cfm-monitor
	enewgroup cfm-monitor
	enewgroup cfm-peripherals
}
