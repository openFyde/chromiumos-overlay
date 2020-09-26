# Copyright 2014 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="ca2f93683dc5b6d0eb9c06d32731f93cc123e4d5"
CROS_WORKON_TREE=("825512278f3738ba8ac7c5f167aacd4677cfebf7" "d7ec5ae2a862b5ec6b4a75d22650579844383a5b" "e0419631c76bfadb1dee2bcda2c68d825087f3f9" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
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
