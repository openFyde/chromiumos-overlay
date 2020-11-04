# Copyright 2015 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="0ab7261926f70b8e1baff1e39d5883493bb9127b"
CROS_WORKON_TREE=("7d6de4299fef55d16dfedeb3723b1a312e0c9acd" "83ea227f90a50ac49e3b16c527a9cc2c81818c50" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_DESTDIR="${S}/platform2"
CROS_WORKON_SUBTREE="common-mk libchromeos-ui .gn"

PLATFORM_NATIVE_TEST="yes"
PLATFORM_SUBDIR="libchromeos-ui"

inherit cros-workon platform

DESCRIPTION="Library used to start Chromium-based UIs"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/libchromeos-ui/"
LICENSE="BSD-Google"
KEYWORDS="*"
IUSE=""

RDEPEND="chromeos-base/bootstat"
DEPEND=""

src_install() {
	local v="$(libchrome_ver)"

	insinto "/usr/$(get_libdir)/pkgconfig"
	./platform2_preinstall.sh "${OUT}" "${v}"
	dolib.so "${OUT}"/lib/libchromeos-ui-"${v}".so
	doins "${OUT}"/lib/libchromeos-ui-"${v}".pc

	insinto /usr/include/chromeos/ui
	doins "${S}"/chromeos/ui/*.h
}

platform_pkg_test() {
	platform_test "run" "${OUT}/libchromeos-ui-test"
}
