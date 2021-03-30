# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT=("70ece0ad8d1216a69e9fd9d83bc65c317931edd1" "6ffaf0f4bc9506c53a50a8b90a0f44d08f62395b")
CROS_WORKON_TREE=("ae528dee9890ab7346a1fee2e50877007ea3e1c0" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb" "44021ce5241d712ce75d8be72c55f0e61dde192b")
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
