# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="ad9c19a78e95087277891bf350b52be041071e86"
CROS_WORKON_TREE=("d81d262abc8e5b1e47c2383e38d271d145d0eed8" "bc5d73e40a959dd5e4fdb5a6431004733015ac5d" "24f974ecfdcda04a1f60a99570eb164001d04205" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
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
