# Copyright 2019 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="f8bdf5fe2aae90f4152056074fe56d76e48663d8"
CROS_WORKON_TREE=("e3b92b04b3b4a9c54c71955052636c95b5d2edcd" "2f3540fa4c17dc3093037123ea3921c49e87556f" "8e903b302ae32619e943f789155d24b7dd59df95" "36b81ce291de8cb3df69049a4a7099019a4373dd" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
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
