# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="390479a033b8259bff8230846d88ff7b4ae5412c"
CROS_WORKON_TREE=("85e4e098023fcccb8851b45c351a7045fa23f06f" "74b1881d789b83599e9a09e6c8fbda67a05af12c" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_DESTDIR="${S}/platform2"
CROS_WORKON_SUBTREE="common-mk ml_benchmark .gn"

DESCRIPTION="Chrome OS ML Benchmarking Suite"

PLATFORM_SUBDIR="ml_benchmark"

inherit cros-workon platform

RDEPEND=""

DEPEND="
	${RDEPEND}
"

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE=""

src_install() {
	dobin "${OUT}"/ml_benchmark
}

platform_pkg_test() {
	platform_test "run" "${OUT}/ml_benchmark_test"
}
