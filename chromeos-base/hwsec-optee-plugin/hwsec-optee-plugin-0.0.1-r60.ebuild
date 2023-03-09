# Copyright 2022 The ChromiumOS Authors
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI=7

CROS_WORKON_COMMIT="74c947f15488f90fe0d66e4c2410c3d37f306a97"
CROS_WORKON_TREE=("3f8a9a04e17758df936e248583cfb92fc484e24c" "4702b7ba54e3dcff8dcf28e0000324fda7971424" "bfe8062c9dc73fd763027d8dcace0cec1529f299" "0da6813244ce2b1b6119bea74143530e6a6623e9" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk hwsec-optee-plugin libhwsec libhwsec-foundation .gn"

PLATFORM_SUBDIR="hwsec-optee-plugin"

inherit cros-workon platform

DESCRIPTION="Optee plugin for hardware security module."
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/hwsec-optee-plugin/"

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE="test"

COMMON_DEPEND="
	chromeos-base/libhwsec:=[test?]
	chromeos-base/optee_client:=
"

RDEPEND="${COMMON_DEPEND}"
DEPEND="${COMMON_DEPEND}"

platform_pkg_test() {
	platform test_all
}
