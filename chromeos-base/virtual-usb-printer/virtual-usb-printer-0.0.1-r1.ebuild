# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=6

CROS_WORKON_COMMIT=("97957b865770ea7caf76d1e8ff81d979aee45d2e" "f086c65c0cbdc0e5b72ec6e7cb763768b1ed8b51")
CROS_WORKON_TREE=("32846ae6bc5a87e046276856720e89529dda1626" "41667ac4153c5664c5032045b96b36a8330e3fd5")
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
