# Copyright 2022 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="9ea7c7658291878bf488dcff635f5adf3e625226"
CROS_WORKON_TREE=("5a857fb996a67f6c9781b916ba2d6076e9dcd0a6" "05da2d429111c57ff6211bd9c5da3fa0ba4781e7" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
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
	platform_src_install

	dobin "${OUT}"/flex_id_tool
}

platform_pkg_test() {
	platform_test "run" "${OUT}/flex_id_test"
}
