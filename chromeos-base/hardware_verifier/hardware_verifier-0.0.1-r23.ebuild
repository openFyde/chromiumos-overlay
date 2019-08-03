# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=6

CROS_WORKON_COMMIT="ca9e4b3e06d7e306777e23c7cf34d8ef2dc6a94f"
CROS_WORKON_TREE=("fb04314ba38f1b698a2ef2ac7178c9dffddfad70" "f6f6a80edc913e2e5845bf2f30dea4abc3d75060" "dc1506ef7c8cfd2c5ffd1809dac05596ec18773c")
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk hardware_verifier .gn"

PLATFORM_SUBDIR="hardware_verifier"

inherit cros-workon platform

DESCRIPTION="Hardware Verifier Tool/Lib for Chrome OS"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/hardware_verifier/"

LICENSE="BSD-Google"
SLOT=0
KEYWORDS="*"

RDEPEND="
	chromeos-base/libbrillo:=
"
DEPEND="
	${RDEPEND}
	chromeos-base/system_api
	chromeos-base/vboot_reference
"

src_install() {
	dobin "${OUT}/hardware_verifier"
}

platform_pkg_test() {
	platform_test "run" "${OUT}/unittest_runner"
}
