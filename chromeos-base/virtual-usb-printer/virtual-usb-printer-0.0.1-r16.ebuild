# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=6

CROS_WORKON_COMMIT=("2779be40022b1d5dfb4c23f5b414f6231427a68b" "0d3da5daff1349c75faa76f8108f8c651c187514")
CROS_WORKON_TREE=("8fafe4805a3e397e87abc5fd68bec0a9d23fde07" "d78d922df339c3112250cce9b13def9763d3ee3b")
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
	net-print/cups
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
