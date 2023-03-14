# Copyright 2021 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="c99ce83aa7c8f6462ffeb3de18dd646e0911ca3e"
CROS_WORKON_TREE=("3f8a9a04e17758df936e248583cfb92fc484e24c" "e2d936f5530be9fdd0daca1449370623d61d8c4a" "4f69dce040c9bf4feac2c175de8d6d87f88df10e" "49314049d93d0e1642a0cb189d47b319b8825b64" "63717750abbb88947589846f282d7c6b1f881649" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk chromeos-config libcrossystem libec runtime_probe .gn"

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
	chromeos-base/cros-camera-libs:=
	chromeos-base/debugd-client:=
	chromeos-base/libcrossystem:=
	chromeos-base/libec:=
	chromeos-base/shill-client:=
	dev-libs/libpcre:=
	media-libs/minigbm:=
"

RDEPEND="
	${COMMON_DEPEND}
	chromeos-base/ec-utils
"

DEPEND="${COMMON_DEPEND}
	chromeos-base/system_api:=[fuzzer?]
"

platform_pkg_test() {
	platform test_all
}
