# Copyright 2021 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="d7e74ccc2b4ef743082cb39b4a472bdc4a85838b"
CROS_WORKON_TREE=("017dc03acde851b56f342d16fdc94a5f332ff42e" "f9c7431caf7b64df59390da12d5015c7b934da90" "4f69dce040c9bf4feac2c175de8d6d87f88df10e" "0a40f73ed729b05b23232a164534d85d2d650e71" "fdad82bd8e910842c16879733dc52eb95142dc8e" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
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
