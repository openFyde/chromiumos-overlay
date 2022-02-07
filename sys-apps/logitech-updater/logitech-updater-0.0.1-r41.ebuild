# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="dcb7e7f86dce2f535ac87eecfe17c48575ded9f1"
CROS_WORKON_TREE="912ab2e98679bf37e71d84053a75bc190a85c343"
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
