# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="136c962a807127d0ed3f8860ec2e60cf2191ce53"
CROS_WORKON_TREE="738ad6b5955cc8ac589a4f9583e6ef51848180f8"
CROS_WORKON_PROJECT="chromiumos/third_party/logitech-updater"

inherit cros-workon libchrome udev user

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
	cros-workon_src_configure
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
