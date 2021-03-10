# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="5f03ce3f3c6b0d190484354cce47934ced7c22ed"
CROS_WORKON_TREE=("eaed4f3b0a8201ef3951bf1960728885ff99e772" "8ff0dc4bc4e276e3279e79c96307f0697abedb56" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
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

DEPEND="${RDEPEND}
	dev-libs/protobuf:=
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
