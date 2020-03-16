# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT=("41b182badc47ce7fe502b91bc24331a845239718" "55a1b16b386ed2aa065c47bbd32a150d798d29af")
CROS_WORKON_TREE=("8c947faeb1713a8ddcec8ee6380cbbbe8fe53a1c" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb" "a16e39e3ecc61684049081eacad0a2a67cda31e8")
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
