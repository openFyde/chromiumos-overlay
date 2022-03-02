# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT=("f253d9dea38f46cd256f5a9193982628f2b1b5e6" "b88c63453b18ef3b6058377aee2cbb5152dda39b")
CROS_WORKON_TREE=("b50e5ebc78fa3b45d6c6ea0ede1aa648d160fb92" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb" "be0db62170e9578effaf0492f97a7568a50fe55e")
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

	local fuzzer_component_id="923964"
	platform_fuzzer_install "${S}/OWNERS" "${OUT}"/reader_fuzzer \
		--comp "${fuzzer_component_id}"
}

platform_pkg_test() {
	platform_test "run" "${OUT}/cbor_unittests"
}
