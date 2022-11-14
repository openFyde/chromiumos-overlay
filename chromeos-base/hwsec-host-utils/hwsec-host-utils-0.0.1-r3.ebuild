# Copyright 2022 The ChromiumOS Authors
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI=7

CROS_WORKON_COMMIT="fab3170274860fa39a5ce5e5d68ed5e9498bccb6"
CROS_WORKON_TREE=("ebcce78502266e81f55c63ade8f25b8888e2c103" "581d3071e551a711e5f7e0586e268912a12fe952" "264ae8e8ad73ab221fc719e5faa59d8d73806d71" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
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
