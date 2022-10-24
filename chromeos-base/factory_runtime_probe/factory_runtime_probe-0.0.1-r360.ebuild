# Copyright 2021 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="f1b2252b9a0c8e03f65e277929a5ee81b1e3a80d"
CROS_WORKON_TREE=("bb46f20bc6d2f9e7fb1aa1178d1e47384440de9a" "c081dfdce33cdc23b6c225e85ad84e61bb77b521" "b46f04f1fa2960327011a0cc74a084a246597e3d" "e59b4070a8ff019210ab349b4a1672edb27c3177" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
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
