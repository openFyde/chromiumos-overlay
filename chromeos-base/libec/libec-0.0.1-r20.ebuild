# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="9a3ff861a9733294d0d2f17f6a7cdd83bf449eb5"
CROS_WORKON_TREE=("cd4404a959be7b308302170c874c3fa5ad50989f" "0c3ac991150c21db311300731f54e240235fb7ee" "ee0e1f96b74e74aaf81c86ee6c997a16475c35aa" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
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
