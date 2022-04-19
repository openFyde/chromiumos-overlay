# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="022f1abaeac591131ddd974d8f76e81d686e02f0"
CROS_WORKON_TREE=("8ff1eab586712c03641dda82a1877dfc4cd6eb72" "01ea4b1e89917ab2eace86defdfd6a6a65655c6b" "923b97b976d8da39a65d9d2dd43aaf3bfe6d2038" "64afe36986923627fe24faf85eb12279b641bb7e" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk chromeos-config hardware_verifier metrics .gn"

PLATFORM_SUBDIR="hardware_verifier"

inherit cros-workon cros-unibuild platform user

DESCRIPTION="Hardware Verifier Tool/Lib for Chrome OS"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/hardware_verifier/"

LICENSE="BSD-Google"
KEYWORDS="*"

DEPEND="
	chromeos-base/chromeos-config-tools:=
	>=chromeos-base/metrics-0.0.1-r3152:=
	chromeos-base/system_api:=
	chromeos-base/vboot_reference:=
"

pkg_preinst() {
	# Create user and group for hardware_verifier
	enewuser "hardware_verifier"
	enewgroup "hardware_verifier"
}

src_install() {
	platform_src_install

	dobin "${OUT}/hardware_verifier"

	insinto /etc/init
	doins init/hardware_verifier.conf
	doins init/hardware_verifier-dbus.conf

	# Install D-Bus configuration file.
	insinto /etc/dbus-1/system.d
	doins dbus/org.chromium.HardwareVerifier.conf

	# Install D-Bus service activation configuration.
	insinto /usr/share/dbus-1/system-services
	doins dbus/org.chromium.HardwareVerifier.service

}

platform_pkg_test() {
	platform_test "run" "${OUT}/unittest_runner"
}
