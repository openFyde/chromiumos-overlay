# Copyright 2015 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="0820492ee68f354de8640570fa57daa5e24ef0d6"
CROS_WORKON_TREE=("e747749e00f36b7c255da2376d5f0e9989bcd2f9" "2361f68127fc1aaed7591baf3a4ad462108f161a" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_DESTDIR="${S}/platform2"
CROS_WORKON_SUBTREE="common-mk libchromeos-ui .gn"

PLATFORM_NATIVE_TEST="yes"
PLATFORM_SUBDIR="libchromeos-ui"

inherit cros-workon platform

DESCRIPTION="Library used to start Chromium-based UIs"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/libchromeos-ui/"
LICENSE="BSD-Google"
KEYWORDS="*"
IUSE=""

RDEPEND="chromeos-base/bootstat"
DEPEND=""

src_install() {
	local v="$(libchrome_ver)"

	insinto "/usr/$(get_libdir)/pkgconfig"
	./platform2_preinstall.sh "${OUT}" "${v}"
	dolib.so "${OUT}"/lib/libchromeos-ui.so
	doins "${OUT}"/lib/libchromeos-ui.pc

	insinto /usr/include/chromeos/ui
	doins "${S}"/chromeos/ui/*.h
}

platform_pkg_test() {
	platform_test "run" "${OUT}/libchromeos-ui-test"
}
