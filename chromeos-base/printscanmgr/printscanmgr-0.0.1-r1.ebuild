# Copyright 2023 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="0313aa5c8ae3c4834f1ec7ee14346489edb98493"
CROS_WORKON_TREE=("f6e687d95778aff2f019e7bfb54e40255774136d" "96daa8dbf7b0bf109539645db1d38fe188b9adb9" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
CROS_WORKON_INCREMENTAL_BUILD="1"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk printscanmgr .gn"

PLATFORM_SUBDIR="printscanmgr"

inherit cros-workon platform user

DESCRIPTION="Chrome OS printing and scanning daemon"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/printscanmgr/"
LICENSE="BSD-Google"
KEYWORDS="*"

COMMON_DEPEND=""

RDEPEND="${COMMON_DEPEND}
	"

DEPEND="${COMMON_DEPEND}
	chromeos-base/system_api:=
	sys-apps/dbus:="

pkg_preinst() {
	enewuser printscanmgr
	enewgroup printscanmgr
}
