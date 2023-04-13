# Copyright 2019 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="4025aab4f7da05fe2b8c37fd89a2943d4e72f794"
CROS_WORKON_TREE=("8fad85aa9518e1a0f04272ae9e077c4a4036297d" "6aeb64d112325ba29ac82c4ca505fe329c1967e7" "f3f402b411d54d6abf597b2b2200c3de14ca1556" "a2002e5b021a481c966a494642397c400fe65c93" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
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
	chromeos-base/runtime_probe-client:=
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
}

platform_pkg_test() {
	platform test_all
}
