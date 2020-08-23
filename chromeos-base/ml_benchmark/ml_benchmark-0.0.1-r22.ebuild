# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="0f2d8cef0c5fa29437a2d56e40dd3003e0e5f503"
CROS_WORKON_TREE=("502ac8c8eeb9e928045eb92752f420ddd406348c" "74b1881d789b83599e9a09e6c8fbda67a05af12c" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
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
