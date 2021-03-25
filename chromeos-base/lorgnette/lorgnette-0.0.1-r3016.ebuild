# Copyright 2014 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="ada4178f4d4516d972f57413e5ab6b00bc70d50e"
CROS_WORKON_TREE=("a58d199d2c4d0e5da40bb5d453f513f5e2c97ae4" "8ee4de33f1f776d8b03f8846ad2a09b17daf837d" "a00337a95a9d26a69d66b71b32e39cc552797f8e" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_INCREMENTAL_BUILD="1"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
# TODO(crbug.com/809389): Avoid directly including headers from other packages.
CROS_WORKON_SUBTREE="common-mk lorgnette metrics .gn"

PLATFORM_SUBDIR="lorgnette"

inherit cros-workon platform user udev

DESCRIPTION="Document Scanning service for Chromium OS"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/lorgnette/"
LICENSE="BSD-Google"
KEYWORDS="*"
IUSE="test"

COMMON_DEPEND="
	>=chromeos-base/metrics-0.0.1-r3152:=
	media-libs/libpng:=
	media-gfx/sane-backends:=
	virtual/libusb:1
"

RDEPEND="${COMMON_DEPEND}
	chromeos-base/minijail
	media-gfx/sane-airscan
	test? (
		media-gfx/perceptualdiff:=
	)
"

DEPEND="${COMMON_DEPEND}
	chromeos-base/permission_broker-client:=
	chromeos-base/system_api:=
"

pkg_preinst() {
	enewgroup ippusb
	enewgroup usbprinter
}

src_install() {
	dobin "${OUT}"/lorgnette
	insinto /etc/dbus-1/system.d
	doins dbus_permissions/org.chromium.lorgnette.conf
	insinto /usr/share/dbus-1/system-services
	doins dbus_service/org.chromium.lorgnette.service
	insinto /etc/init
	doins init/lorgnette.conf
	udev_dorules udev/*.rules
}

platform_pkg_test() {
	platform_test "run" "${OUT}/lorgnette_unittest"
}
