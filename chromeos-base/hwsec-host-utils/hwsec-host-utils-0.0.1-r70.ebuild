# Copyright 2022 The ChromiumOS Authors
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI=7

CROS_WORKON_COMMIT="9e6b424caa95299b286811d4b6c1f3783edc77bd"
CROS_WORKON_TREE=("e44d7e66ab4ccaab888a42ade972724af9621706" "d818c74755ac1a298f205ac7e4bdea67d6c6f6ef" "70212877aaf6587f9ee6015b92f0bcd6b8fb7ce9" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
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
