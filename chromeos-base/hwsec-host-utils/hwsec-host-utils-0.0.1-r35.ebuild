# Copyright 2022 The ChromiumOS Authors
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI=7

CROS_WORKON_COMMIT="d6d039500516434425e66edc3b63fac1e8eb1ffc"
CROS_WORKON_TREE=("aaaaa3f7d8b4455b36eba6a9874fca10fefb836c" "5d16c4d35ebef1332b6943ec55cf467e0157cf5a" "c1efe204d8d96e56aa381495efb76322efadbc40" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk hwsec-host-utils trunks .gn"

PLATFORM_SUBDIR="hwsec-host-utils"

inherit cros-workon platform

DESCRIPTION="Hwsec-related host-only utilities."
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/hwsec-host-utils/"

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE="cros_host"
REQUIRED_USE="cros_host"

COMMON_DEPEND="
	chromeos-base/trunks:=
	app-crypt/trousers:=
"
RDEPEND="${COMMON_DEPEND}"
DEPEND="${COMMON_DEPEND}"

src_install() {
	platform_src_install
}

platform_pkg_test() {
	platform test_all
}
