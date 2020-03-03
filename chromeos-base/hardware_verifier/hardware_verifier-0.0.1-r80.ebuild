# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="940ca4da805d83c9e25919c7146bee62523d6c57"
CROS_WORKON_TREE=("03bbbcee411f17ba1fc689765743cc4876d16cbb" "ec68ff5950e448164fc020d96192ffef2f075dce" "7e090ba54425d36a9899ce32e6195fa8e1b93335" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk hardware_verifier metrics .gn"

PLATFORM_SUBDIR="hardware_verifier"

inherit cros-workon platform

DESCRIPTION="Hardware Verifier Tool/Lib for Chrome OS"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/hardware_verifier/"

LICENSE="BSD-Google"
KEYWORDS="*"

DEPEND="
	chromeos-base/metrics:=
	chromeos-base/system_api:=
	chromeos-base/vboot_reference:=
"

src_install() {
	dobin "${OUT}/hardware_verifier"
}

platform_pkg_test() {
	platform_test "run" "${OUT}/unittest_runner"
}
