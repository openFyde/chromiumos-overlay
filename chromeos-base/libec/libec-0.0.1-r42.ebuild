# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="97677467f42e280fa89b51dde849515cda66dbe0"
CROS_WORKON_TREE=("6886eaa44fae8859a23483305e68e13a82a60f8d" "cc8ae75ea68e5c37c867b396c0540c8a109ed460" "667180eb5db7eb65a292552b106b32aa5881c9eb" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_USE_VCSID="1"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="biod common-mk libec .gn"

PLATFORM_SUBDIR="libec"

inherit cros-workon platform

DESCRIPTION="Embedded Controller Library for Chromium OS"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/libec"

LICENSE="BSD-Google"
KEYWORDS="*"

COMMON_DEPEND=""

RDEPEND="
	${COMMON_DEPEND}
	"

DEPEND="
	${COMMON_DEPEND}
	chromeos-base/chromeos-ec-headers:=
"

src_install() {
	dolib.so "${OUT}"/lib/libec*.so
	dolib.a "${OUT}"/libec*.a

	insinto /usr/"$(get_libdir)"/pkgconfig
	doins "${OUT}"/obj/libec/libec*.pc

	insinto /usr/include/libec
	doins ./*.h

	insinto /usr/include/libec/fingerprint
	doins ./fingerprint/*.h
}

platform_pkg_test() {
	platform_test "run" "${OUT}/libec_tests"
}
