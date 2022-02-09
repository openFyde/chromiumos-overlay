# Copyright 2015 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="07c65ddc3d0f3a2d0d1e267604dd6a707ca57d3e"
CROS_WORKON_TREE=("2f8a3fd5e0af952f605c8e7b8afa1ecedad683fa" "a88378f84563bfeb2d78d1d3f104fb180c574c1b" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
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
	dolib.so "${OUT}"/lib/libchromeos-ui.so
	doins "${OUT}"/lib/libchromeos-ui.pc

	insinto /usr/include/chromeos/ui
	doins "${S}"/chromeos/ui/*.h
}

platform_pkg_test() {
	platform_test "run" "${OUT}/libchromeos-ui-test"
}
