# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CROS_WORKON_COMMIT=("5754a23f1e0c393f2edc41f5e4e159005c9b80b5" "a5510e1f1d06e09f905a5077e573cc610f191eeb")
CROS_WORKON_TREE=("3187b1cb305c8252aae1be2602c9a517cb2347fa" "970c56064b0f3c9174aec845bf40a8c73316c2c1")
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
