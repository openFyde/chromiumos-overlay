# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT=("c90aa6f17dcbdeaf4e7c5ce155f3a685afdbfd01" "de14261b0d6c9fe054f2e1b95faed6c325f34f47")
CROS_WORKON_TREE=("6efa0db0e49014be7389d66af98ab7469b93fc60" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb" "a16e39e3ecc61684049081eacad0a2a67cda31e8")
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
