# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="c558afc61ead81bf4f4b9d18a16da2046b36a0f1"
CROS_WORKON_TREE=("b2e87d3910785f0483157ecf4a2941ac2809e907" "a19f3c13e846757b23049b29f701c74144ce210c" "2bc172b68cfe0581cc7386357662c94331c96c6b" "86c393728c91ab045ff4d432bdc9681bcb469436" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk chromeos-config hardware_verifier metrics .gn"

PLATFORM_SUBDIR="hardware_verifier"

inherit cros-workon platform user

DESCRIPTION="Hardware Verifier Tool/Lib for Chrome OS"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/hardware_verifier/"

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE="generated_cros_config unibuild"

DEPEND="
	unibuild? (
		!generated_cros_config? ( chromeos-base/chromeos-config:= )
		generated_cros_config? ( chromeos-base/chromeos-config-bsp:= )
	)
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
	dobin "${OUT}/hardware_verifier"

	insinto /etc/init
	doins init/hardware-verifier.conf
}

platform_pkg_test() {
	platform_test "run" "${OUT}/unittest_runner"
}
