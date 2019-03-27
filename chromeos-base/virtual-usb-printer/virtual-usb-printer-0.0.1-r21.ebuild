# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=6

CROS_WORKON_COMMIT=("8eda3b498fd82b6dd3c01ff3b4d8c8a0d125f8f2" "3c4785cb3e14efcf255ef615a41f7178ab743661")
CROS_WORKON_TREE=("13228e56ac75327ed92fe81d6a0ed4f5c11c2a6a" "9aea355bfa1a7aa79072718e4a7ff9f1709d5dd5")
CROS_WORKON_LOCALNAME=("platform2" "third_party/virtual-usb-printer")
CROS_WORKON_PROJECT=("chromiumos/platform2" "chromiumos/third_party/virtual-usb-printer")
CROS_WORKON_DESTDIR=("${S}/platform2" "${S}/third_party/virtual-usb-printer")
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_SUBTREE=("common-mk" "")

PLATFORM_SUBDIR="virtual_usb_printer"

inherit cros-workon platform

DESCRIPTION="Used with USBIP to provide a virtual USB printer for testing."
HOMEPAGE="https://chromium.googlesource.com/chromiumos/third_party/virtual-usb-printer/"

LICENSE="GPL-2"
SLOT=0
KEYWORDS="*"

IUSE="usbip"

RDEPEND="
	chromeos-base/libbrillo:=
	usbip? ( net-misc/usbip )
"

DEPEND="${RDEPEND}"

src_unpack() {
	local s="${S}"
	platform_src_unpack
	S="${s}/third_party/virtual-usb-printer"
}

platform_pkg_test() {
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
