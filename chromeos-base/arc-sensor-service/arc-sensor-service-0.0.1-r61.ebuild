# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="53eb7dac34bd189fa74f7e18f11a939bdfd33a27"
CROS_WORKON_TREE=("a58d199d2c4d0e5da40bb5d453f513f5e2c97ae4" "1ff76b6a39cce9a87bca1bf4be3299ed772d0abe" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
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
