# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="8f87ac8f1ddd9b7f59ee105ebd7fa5efe737e953"
CROS_WORKON_TREE=("6c9716db399911cdc121210cb221d310182a10f3" "77b26d99b1c59a62c53b3c3b30e69121a39b565f" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_INCREMENTAL_BUILD="1"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk libmems .gn"

PLATFORM_SUBDIR="libmems"

inherit cros-workon platform

DESCRIPTION="MEMS support library for Chromium OS."
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/libmems"

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE=""

COMMON_DEPEND="
	net-libs/libiio:="
RDEPEND="${COMMON_DEPEND}"
DEPEND="${COMMON_DEPEND}
	chromeos-base/system_api:="

src_install() {
	dolib.so "${OUT}/lib/libmems.so"
	dolib.so "${OUT}/lib/libmems_test_support.so"

	insinto "/usr/$(get_libdir)/pkgconfig"
	doins libmems.pc
	doins libmems_test_support.pc

	insinto "/usr/include/chromeos/libmems"
	doins *.h
}

platform_pkg_test() {
	local tests=(
		libmems_testrunner
	)

	local test_bin
	for test_bin in "${tests[@]}"; do
		platform_test "run" "${OUT}/${test_bin}"
	done
}

