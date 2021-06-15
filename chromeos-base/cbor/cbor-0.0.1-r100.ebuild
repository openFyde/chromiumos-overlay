# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT=("a4b3f802aa9e010e2396f2fa700cc17630d6cd74" "6d5abcafdfda3c78f64cb242c8d7e8076c5af451")
CROS_WORKON_TREE=("062a6da7fe49dd18c96ec59ac08784111d37b2c3" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb" "f5f3d15e265fd3d3816c4b9533ecd5f3c05cf927")
CROS_WORKON_PROJECT=(
	"chromiumos/platform2"
	"chromiumos/platform/cbor"
)

CROS_WORKON_LOCALNAME=(
	"platform2"
	"platform/cbor"
)

CROS_WORKON_DESTDIR=(
	"${S}/platform2"
	# This needs to be platform2/cbor instead of platform/cbor because we are
	# using the platform2 build system.
	"${S}/platform2/cbor"
)

CROS_WORKON_SUBTREE=("common-mk .gn" "")

PLATFORM_SUBDIR="cbor"

inherit cros-workon platform

DESCRIPTION="Concise Binary Object Representation (CBOR) library for Chromium OS"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform/cbor"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"

src_install() {
	dolib.so "${OUT}"/lib/libcbor.so
	insinto /usr/include/chromeos/cbor/
	doins ./*.h
	insinto "/usr/$(get_libdir)/pkgconfig"
	doins "${OUT}"/obj/cbor/cbor.pc

	platform_fuzzer_install "${S}/OWNERS" "${OUT}"/reader_fuzzer
}

platform_pkg_test() {
	platform_test "run" "${OUT}/cbor_unittests"
}
