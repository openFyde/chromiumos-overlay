# Copyright 2015 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="1884e3c82b742377769be62d58adeb080e431553"
CROS_WORKON_TREE=("9af4067326e0bd0aaade6270a9312a91ca2642ed" "52ffb399285c37f42cce58aee9c40b7226f4c603" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
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


COMMON_DEPEND="chromeos-base/chromeos-config-tools:="
RDEPEND="
	${COMMON_DEPEND}
	chromeos-base/bootstat
"
DEPEND="${COMMON_DEPEND}"

src_install() {
	platform_src_install

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
