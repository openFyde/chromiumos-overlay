# Copyright 2020 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="4976e32ebaf56e78afff4cf4ec3fc066e20c82a4"
CROS_WORKON_TREE=("2f5486f5d231a8a7920e3033439b1ae644f07f5d" "34bbb907e299188b374561d2aa4329c405497412" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
CROS_WORKON_INCREMENTAL_BUILD="1"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk arc/vm/host_clock .gn"

PLATFORM_SUBDIR="arc/vm/host_clock"

inherit cros-workon platform user

DESCRIPTION="ARC host clock service"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/arc/vm/host_clock"

LICENSE="BSD-Google"
KEYWORDS="*"

RDEPEND="
"

DEPEND="
	${RDEPEND}
	chromeos-base/system_api
"

src_install() {
	platform_src_install
}

pkg_preinst() {
	enewuser "arc-host-clock"
	enewgroup "arc-host-clock"
}
