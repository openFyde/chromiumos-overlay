# Copyright 2014 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="81ab653dea22fb44fdc89c7bda55319b5fa78cfd"
CROS_WORKON_TREE=("deae25aff188ab5ba0e93e5a3b5dbdad82b01b02" "c6e881f5bb7d9c946bee7dacd74d851ab90abf05" "7c49faa8392a94e14ae32a1d4ee7177ab7307c2a" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
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
