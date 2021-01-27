# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="0d5c8329c95d45206518b2b0420e9045166b19db"
CROS_WORKON_TREE=("039ed44189c17a7037215fc778a6f1fcb96b1433" "4dc9e176d315085cb2b8c8ad66d1965575ef5280" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_DESTDIR="${S}/platform2"
CROS_WORKON_SUBTREE="common-mk ml_benchmark .gn"

DESCRIPTION="Chrome OS ML Benchmarking Suite"

PLATFORM_SUBDIR="ml_benchmark"

inherit cros-workon platform

# chromeos-base/ml_benchmark blocked due to package rename
RDEPEND="
	!chromeos-base/ml_benchmark
"

DEPEND="
	${RDEPEND}
"

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE=""

src_install() {
	dobin "${OUT}"/ml_benchmark
	dolib.so "${OUT}"/lib/libmlbenchmark_proto.so
}

platform_pkg_test() {
	platform_test "run" "${OUT}/ml_benchmark_test"
}
