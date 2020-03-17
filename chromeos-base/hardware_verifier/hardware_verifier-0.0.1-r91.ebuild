# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="2c9f5f4dbbe7ab2e788961194484d975cbb9380f"
CROS_WORKON_TREE=("94bdce168a00f19903b3dd162e8e755cee9bbbf8" "0685967a7bcd0dc5de0be12c786b23f606ac4562" "f80bd0721a67127e04dde4362dfcb1c39051698e" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk hardware_verifier metrics .gn"

PLATFORM_SUBDIR="hardware_verifier"

inherit cros-workon platform user

DESCRIPTION="Hardware Verifier Tool/Lib for Chrome OS"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/hardware_verifier/"

LICENSE="BSD-Google"
KEYWORDS="*"

DEPEND="
	chromeos-base/metrics:=
	chromeos-base/system_api:=
	chromeos-base/vboot_reference:=
"

pkg_preinst() {
	# Create user and group for hardware_verifier
	enewuser "hardware_verifier"
	enewgroup "hardware_verifier"
}

src_install() {
	dobin "${OUT}/hardware_verifier"

	insinto /etc/init
	doins init/hardware-verifier.conf
}

platform_pkg_test() {
	platform_test "run" "${OUT}/unittest_runner"
}
