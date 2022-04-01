# Copyright 2022 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="44c46742d7eaabcb38ef5abd36c8e27742f7613f"
CROS_WORKON_TREE=("20fecf8e8aefa548043f2cb501f222213c15929d" "e7eb58992509d20f75642f5d21be59abc30af313" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_DESTDIR="${S}/platform2"
CROS_WORKON_SUBTREE="common-mk flex_id .gn"

PLATFORM_SUBDIR="flex_id"

inherit cros-workon platform

DESCRIPTION="Utility to generate Flex ID for Chromium OS"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/flex_id"

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE=""

RDEPEND="!chromeos-base/client_id"

src_install() {
	dobin "${OUT}"/flex_id_tool
}

platform_pkg_test() {
	platform_test "run" "${OUT}/flex_id_test"
}
