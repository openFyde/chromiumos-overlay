# Copyright 2022 The ChromiumOS Authors
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI=7

CROS_WORKON_COMMIT="4025aab4f7da05fe2b8c37fd89a2943d4e72f794"
CROS_WORKON_TREE=("8fad85aa9518e1a0f04272ae9e077c4a4036297d" "4702b7ba54e3dcff8dcf28e0000324fda7971424" "c0264ace18f901db759964a1f346331f593daaf7" "e8eaf496dd281c6b06fb6e927224b710c923ddc0" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
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
