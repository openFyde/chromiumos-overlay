# Copyright 2015 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="89d3c0078a4dabc9e83b2e6d0273d6f2e2a53908"
CROS_WORKON_TREE=("f063c143da4054868aadc5be54cc3a45415a698e" "33ce97f2876e0c3e6618f96cd8e577784d757512" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
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
