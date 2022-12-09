# Copyright 2022 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="31abb64910dfe1fd6cb9898571614acd7c04a8a9"
CROS_WORKON_TREE=("0c4b88db0ba1152616515efb0c6660853232e8d0" "54774b38e37b829b3f2c35d88c74e02437f6542c" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
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
