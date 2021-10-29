# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT=("91d24f3a2ab509418bcca3e174a3b779744f0afa" "8eee5c2a4d8ccb54f6b130a9bc10e8305bbaa254")
CROS_WORKON_TREE=("f9c9ff0f07a0e5d4015af871a558204de304bb90" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb" "57784331a5ffc5567150d508b08b30c5e35fab91")
CROS_WORKON_LOCALNAME=("platform2" "third_party/virtual-usb-printer")
CROS_WORKON_PROJECT=("chromiumos/platform2" "chromiumos/third_party/virtual-usb-printer")
CROS_WORKON_EGIT_BRANCH=("main" "master")
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
	platform_test "run" "${OUT}/cardinality-helper-testrunner"
	platform_test "run" "${OUT}/escl-manager-testrunner"
	platform_test "run" "${OUT}/http-util-testrunner"
	platform_test "run" "${OUT}/ipp-manager-testrunner"
	platform_test "run" "${OUT}/ipp-matching-testrunner"
	platform_test "run" "${OUT}/ipp-matching-validation-testrunner"
	platform_test "run" "${OUT}/ipp-util-testrunner"
	platform_test "run" "${OUT}/jpeg-util-testrunner"
	platform_test "run" "${OUT}/load-config-testrunner"
	platform_test "run" "${OUT}/proto-to-libipp-testrunner"
	platform_test "run" "${OUT}/smart-buffer-testrunner"
	platform_test "run" "${OUT}/wrapped-test-case-step-testrunner"
}

src_install() {
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
	doins config/usb_printer.json

	# Install upstart files into rootfs, since upstart won't look in
	# /usr/local/etc.
	insinto /etc/init
	doins init/virtual-usb-printer.conf
}
