# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="6d2b3c751a220f16e81e0e7add3e8a76cb0e24c3"
CROS_WORKON_TREE="0493d4a4d4d92b9f6fa6070a3fd11a1cbe41ae6a"
CROS_WORKON_PROJECT="chromiumos/third_party/huddly-updater"

inherit cros-workon libchrome udev user

DESCRIPTION="A utility to update Huddly camera firmware"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/third_party/huddly-updater"

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE="test"

COMMON_DEPEND="chromeos-base/libbrillo:=
	chromeos-base/cfm-dfu-notification:=
	dev-libs/msgpack:=
	virtual/libusb:1
	virtual/libudev:0=
"

DEPEND="${COMMON_DEPEND}
	test? ( dev-cpp/gtest:= )
"

RDEPEND="${COMMON_DEPEND}
	app-arch/unzip
"

src_configure() {
	cros-workon_src_configure
}

src_test() {
	if use amd64; then
		emake tests
	fi
}

src_install() {
	dosbin huddly-updater
	dosbin huddly-hpk-updater
	udev_dorules conf/99-huddly.rules
}

pkg_preinst() {
	enewuser cfm-firmware-updaters
	enewgroup cfm-firmware-updaters
}
