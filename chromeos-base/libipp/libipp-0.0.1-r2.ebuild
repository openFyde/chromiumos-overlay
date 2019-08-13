# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=6

CROS_WORKON_COMMIT="98fd3540b8d4c57607eb0e2f3af0af071af9db49"
CROS_WORKON_TREE=("fdb2f6bdb65a4fc63e472dfd681acee205c29457" "cb40b8b37a0d9cc301a994856069b016d5cd48d7" "dc1506ef7c8cfd2c5ffd1809dac05596ec18773c")
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
