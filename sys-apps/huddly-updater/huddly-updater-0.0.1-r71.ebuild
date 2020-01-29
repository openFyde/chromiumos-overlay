# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="5251a810f116bc17d8d62f4b3a7eda8c1392e236"
CROS_WORKON_TREE="9a27c6124892667fc9d8df72437f24d877c697fd"
CROS_WORKON_PROJECT="chromiumos/third_party/huddly-updater"

inherit cros-workon libchrome udev user

DESCRIPTION="A utility to update Huddly camera firmware"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/third_party/huddly-updater"

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE="test"

COMMON_DEPEND="chromeos-base/libbrillo:=
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
