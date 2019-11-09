# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=6

CROS_WORKON_COMMIT="757675c0110ee2de0b787f8408417a201ea7d641"
CROS_WORKON_TREE=("13277321c94a2f8ea0ff6bf7d8c246ffd349380a" "a428a7fc4c82cf281c9431b8b038bb7ec7afa02e" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk libipp .gn"

PLATFORM_SUBDIR="libipp"

inherit cros-workon platform

DESCRIPTION="The library for building and parsing IPP (Internet Printing Protocol) frames."
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/libipp/"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"

src_install() {
	dolib.so "${OUT}/lib/libipp.so"

	insinto "/usr/$(get_libdir)/pkgconfig"
	doins libipp.pc

	insinto "/usr/include/chromeos/libipp"
	doins ipp.h ipp_attribute.h ipp_base.h ipp_collections.h ipp_enums.h \
			ipp_export.h ipp_operations.h ipp_package.h

	# Install fuzzer
	platform_fuzzer_install "${S}"/OWNERS "${OUT}"/libipp_fuzzer
}

platform_pkg_test() {
	platform_test "run" "${OUT}/libipp_test"
}
