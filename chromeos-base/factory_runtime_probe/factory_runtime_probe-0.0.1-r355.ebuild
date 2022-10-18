# Copyright 2021 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="4444802f98c5b7e8d3ee5e6794b60f6a4c7f2ce5"
CROS_WORKON_TREE=("bb46f20bc6d2f9e7fb1aa1178d1e47384440de9a" "bbe1aadbe90ae34828c6b8a1e3b034d9cdd19662" "519533f5905e311e1f93fd184a2a9140a19e7038" "82c0966b4d6a9afd04b53d31dce7ad2c03faa19a" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
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

platform_pkg_test() {
	platform test_all
}
