# Copyright 2023 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="db50fe0ee6a2e2756fd40d261155c240548ad26b"
CROS_WORKON_TREE=("92a7718bfe5a15c594fcc6b0855e68b0981cd9a0" "9917f8b0bbfefe1678eff595d8cf521a4e52ca32" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
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

COMMON_DEPEND="
	chromeos-base/minijail:=
"

RDEPEND="${COMMON_DEPEND}
	"

DEPEND="${COMMON_DEPEND}
	chromeos-base/system_api:=
	sys-apps/dbus:="

pkg_preinst() {
	enewuser printscanmgr
	enewgroup printscanmgr
}
