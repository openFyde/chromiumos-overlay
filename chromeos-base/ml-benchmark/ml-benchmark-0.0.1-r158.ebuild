# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="f253d9dea38f46cd256f5a9193982628f2b1b5e6"
CROS_WORKON_TREE=("b50e5ebc78fa3b45d6c6ea0ede1aa648d160fb92" "fdd0209826719268c01d190ed7bbfa76b177f2f5" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
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
	vulkan? ( media-libs/clvk )
"

DEPEND="${RDEPEND}
	dev-libs/protobuf:=
"

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE="vulkan"

src_install() {
	platform_install
}

platform_pkg_test() {
	platform test_all
}
