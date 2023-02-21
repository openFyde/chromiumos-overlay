# Copyright 2019 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT=("db50fe0ee6a2e2756fd40d261155c240548ad26b" "503505a16438e10319da900acc870f82859682c7")
CROS_WORKON_TREE=("92a7718bfe5a15c594fcc6b0855e68b0981cd9a0" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6" "24e68eeafcd30be603b9498a0f00d88a0b8d9de4")
CROS_WORKON_LOCALNAME=("platform2" "third_party/virtual-usb-printer")
CROS_WORKON_PROJECT=("chromiumos/platform2" "chromiumos/third_party/virtual-usb-printer")
CROS_WORKON_EGIT_BRANCH=("main" "chromeos")
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
	chromeos-base/libipp:=
	dev-libs/libxml2:=
	dev-libs/protobuf:=
	net-misc/usbip:=
	virtual/jpeg:0=
"

DEPEND="${RDEPEND}"

platform_pkg_test() {
	platform_test "run" "${OUT}/escl-manager-testrunner"
	platform_test "run" "${OUT}/http-util-testrunner"
	platform_test "run" "${OUT}/ipp-manager-testrunner"
	platform_test "run" "${OUT}/ipp-util-testrunner"
	platform_test "run" "${OUT}/jpeg-util-testrunner"
	platform_test "run" "${OUT}/load-config-testrunner"
	platform_test "run" "${OUT}/mock-printer-testrunner"
	platform_test "run" "${OUT}/smart-buffer-testrunner"
	platform_test "run" "${OUT}/usb-printer-testrunner"
}

src_install() {
	platform_src_install

	# Install main files into /usr/local even though the ebuild is being
	# installed on the rootfs.
	into /usr/local
	dobin "${OUT}"/virtual-usb-printer

	insinto /usr/local/etc/virtual-usb-printer
	doins config/escl_capabilities.json
	doins config/escl_capabilities_large_paper_sizes.json
	doins config/escl_capabilities_left_justified.json
	doins config/escl_capabilities_center_justified.json
	doins config/escl_capabilities_right_justified.json
	doins config/ipp_attributes.json
	doins config/ippusb_printer.json
	doins config/ippusb_backflip_printer.json
	doins config/ippusb_printer_plus_storage.json
	doins config/usb_printer.json

	# Install upstart files into rootfs, since upstart won't look in
	# /usr/local/etc.
	insinto /etc/init
	doins init/virtual-usb-printer.conf
}
