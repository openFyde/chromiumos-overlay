# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="b4fb27a3ef2f91166ee598162fc2a205a0690c87"
CROS_WORKON_TREE="fc3ce3eddfafa57b6388c0c9d347b2d81b51be0a"
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
