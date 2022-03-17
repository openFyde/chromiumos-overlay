# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="927b44e38d83c189b2a2f12e6e18b67e32c3bb42"
CROS_WORKON_TREE="4bd47ab932a69f928b223223f45fb335c0e9fddb"
CROS_WORKON_PROJECT="chromiumos/third_party/logitech-updater"

inherit cros-debug cros-workon libchrome udev user

DESCRIPTION="Logitech firmware updater"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/third_party/logitech-updater"

LICENSE="BSD-Google"
KEYWORDS="*"

COMMON_DEPEND="chromeos-base/libbrillo:=
	virtual/libusb:1=
	chromeos-base/cfm-dfu-notification:=
"

RDEPEND="${COMMON_DEPEND}"
DEPEND="${COMMON_DEPEND}"

src_configure() {
	# See crbug/1078297
	cros-debug-add-NDEBUG
	default
}

src_install() {
	dosbin logitech-updater
	udev_dorules conf/99-logitech-updater.rules

	# Install seccomp policy.
	insinto "/usr/share/policy"
	newins "seccomp/logitech-updater-seccomp-${ARCH}.policy" logitech-updater-seccomp.policy
}

pkg_preinst() {
	enewuser cfm-firmware-updaters
	enewgroup cfm-firmware-updaters
}
