# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="9eb30f9bd7ea687b61411060d3e70c8b4d35c466"
CROS_WORKON_TREE=("cc8ae75ea68e5c37c867b396c0540c8a109ed460" "3015e8a70d222fc2303b662584083558abab696c" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_INCREMENTAL_BUILD="1"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk arc/vm/sensor_service .gn"

PLATFORM_SUBDIR="arc/vm/sensor_service"

inherit cros-workon platform

DESCRIPTION="ARC sensor service."
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/arc/vm/sensor_service"

LICENSE="BSD-Google"
KEYWORDS="*"

RDEPEND="
"

DEPEND="
	${RDEPEND}
"

src_install() {
	dobin "${OUT}"/arc_sensor_service

	insinto /etc/init
	doins init/arc-sensor-service.conf

	insinto /etc/dbus-1/system.d
	doins init/dbus-1/org.chromium.ArcSensorService.conf
}

platform_pkg_test() {
	platform_test "run" "${OUT}/arc_sensor_service_testrunner"
}
