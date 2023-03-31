# Copyright 2022 The ChromiumOS Authors
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI=7

CROS_WORKON_COMMIT="e364b159e56f23ece2af994214187c650908d14f"
CROS_WORKON_TREE=("04da1711dfcf3e15f8ffb8bc59e4fc277481515b" "4702b7ba54e3dcff8dcf28e0000324fda7971424" "cd99f60efa1abdfe04cd4e2ebe5b092f50d3c3c5" "300a0f13961978d92feb2a2051d0606ae7407e53" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
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
