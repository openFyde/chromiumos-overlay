# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="6bc59e14dd19db0e3ad202e7f3044ca0fcaa963d"
CROS_WORKON_TREE=("f86b3dad942180ce041d9034a4f5f9cceb8afe6b" "44c5547bd8172c662a4e7fce3f09ae6795492eba" "41e588aa09391b289425ae58c40be138298c6cb0" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
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
	dobin "${OUT}/hardware_verifier"

	insinto /etc/init
	doins init/hardware-verifier.conf
}

platform_pkg_test() {
	platform_test "run" "${OUT}/unittest_runner"
}
