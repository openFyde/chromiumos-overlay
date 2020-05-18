# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT=("352e61e15c8a294b4c8903556015c49ca1c175f0" "b82161da9c15b36d7e84ee5ea0d8abb5377892b2")
CROS_WORKON_TREE=("2117aff37f7d1324e283d78595a793c34f98ca7c" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb" "430057118e6c2077774a2d5b1899d3b8d4f0a675")
CROS_WORKON_LOCALNAME=("platform2" "third_party/virtual-usb-printer")
CROS_WORKON_PROJECT=("chromiumos/platform2" "chromiumos/third_party/virtual-usb-printer")
CROS_WORKON_DESTDIR=("${S}/platform2" "${S}/platform2/virtual-usb-printer")
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_SUBTREE=("common-mk .gn" "")

PLATFORM_SUBDIR="virtual-usb-printer"

inherit cros-workon platform

DESCRIPTION="Used with USBIP to provide a virtual USB printer for testing."
HOMEPAGE="https://chromium.googlesource.com/chromiumos/third_party/virtual-usb-printer/"

LICENSE="GPL-2"
KEYWORDS="*"

IUSE=""

RDEPEND="
	net-misc/usbip:=
"

DEPEND="${RDEPEND}"

platform_pkg_test() {
	platform_test "run" "${OUT}/http-util-testrunner"
	platform_test "run" "${OUT}/ipp-util-testrunner"
	platform_test "run" "${OUT}/load-config-testrunner"
	platform_test "run" "${OUT}/smart-buffer-testrunner"
}

src_install() {
	dobin "${OUT}"/virtual-usb-printer
	insinto /etc/virtual-usb-printer
	doins config/ipp_attributes.json
	doins config/ippusb_printer.json
	doins config/usb_printer.json
}
