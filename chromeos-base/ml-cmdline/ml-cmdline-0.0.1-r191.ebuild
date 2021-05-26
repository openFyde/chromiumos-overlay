# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="321920d34d0df9a65fcd2234f10d5f3d669aea79"
CROS_WORKON_TREE=("bf90d72feeef97f2eed78621b91da11dc16e9927" "932f23a9c83525a732dd55cdaa77b8ed74f38755" "0708c26e546583ec621cd9afb1eec94932a10621" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_DESTDIR="${S}/platform2"
CROS_WORKON_SUBTREE="common-mk ml ml_benchmark .gn"

PLATFORM_SUBDIR="ml"

inherit cros-workon platform

DESCRIPTION="Command line interface to machine learning service for Chromium OS"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/ml"

LICENSE="BSD-Google"
KEYWORDS="*"
SLOT="0/0"
IUSE="internal"

RDEPEND="
	chromeos-base/chrome-icu:=
	>=chromeos-base/metrics-0.0.1-r3152:=
	chromeos-base/ml:=
	sci-libs/tensorflow:=
"

DEPEND="
	${RDEPEND}
"

src_install() {
	dobin "${OUT}"/ml_cmdline
}

platform_pkg_test() {
	platform_test "run" "${OUT}/ml_cmdline_test"
}
