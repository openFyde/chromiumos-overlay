# Copyright 2022 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="eb0846c656180dd81522e64a8fecea93b2322645"
CROS_WORKON_TREE=("e3b92b04b3b4a9c54c71955052636c95b5d2edcd" "a0692478cafb0f282147b3a691be5acd7e2ee427" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
CROS_WORKON_INCREMENTAL_BUILD="1"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk swap_management .gn"

PLATFORM_SUBDIR="swap_management"

inherit cros-workon platform

DESCRIPTION="ChromeOS swap management service"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/swap_management/"
LICENSE="BSD-Google"
SLOT="0/0"
KEYWORDS="*"

COMMON_DEPEND="
	chromeos-base/minijail:=
	dev-libs/protobuf:="

RDEPEND="${COMMON_DEPEND}"

DEPEND="${COMMON_DEPEND}
	chromeos-base/system_api:=
	sys-apps/dbus:="
