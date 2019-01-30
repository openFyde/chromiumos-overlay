# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=6

CROS_WORKON_COMMIT=("880bd2dff2582479fa4f44587f43a560186e9796" "6f7fe1fdbae6046475baf37471074adb9cc9d6f7")
CROS_WORKON_TREE=("6f3abf0e1487e52593fe1b4fc780df5844fa9cc1" "90efadeb209832a64034f0e17333e260cc0a3298")
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

RDEPEND="
	chromeos-base/libbrillo:=
	net-print/cups
"

DEPEND="${RDEPEND}"

src_unpack() {
	local s="${S}"
	platform_src_unpack
	S="${s}/third_party/virtual-usb-printer"
}

platform_pkg_test() {
	platform_test "run" "${OUT}/load-config-testrunner"
	platform_test "run" "${OUT}/smart-buffer-testrunner"
}

src_install() {
	dobin "${OUT}"/virtual-usb-printer
	insinto /etc/virtual-usb-printer
	doins config/usb_printer.json
}
