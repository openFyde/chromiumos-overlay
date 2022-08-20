# Copyright 2021 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="16fcd93b78b5265da2dd9c01669e574602fc89e3"
CROS_WORKON_TREE=("702155bb86de2fd19e985a30ab9833bd73f715f7" "4998fa7be14de47381597bdbd8f92c98fbaf389a" "1dbf281b6523338c1a11135ebaf00796f0f664e4" "95a6e0517b7f870315ff2b077e03f9bdecfdf518" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk chromeos-config libec runtime_probe .gn"

PLATFORM_SUBDIR="runtime_probe/factory_runtime_probe"

inherit cros-workon cros-unibuild platform

DESCRIPTION="Device component probe tool **for factory environment**."
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/runtime_probe/"

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE="cros-debug"

# TODO(yhong): Extract common parts with runtime_probe-9999.ebuild to a shared
#     eclass.

COMMON_DEPEND="
	chromeos-base/chromeos-config-tools:=
"

RDEPEND="
	${COMMON_DEPEND}
	chromeos-base/ec-utils
"

# Add vboot_reference as build time dependency to read cros_debug status
DEPEND="${COMMON_DEPEND}
	chromeos-base/debugd-client:=
	chromeos-base/libec:=
	chromeos-base/shill-client:=
	chromeos-base/system_api:=
	chromeos-base/vboot_reference:=
	media-libs/minigbm:=
"

src_install() {
	platform_install
}

platform_pkg_test() {
	platform test_all
}
