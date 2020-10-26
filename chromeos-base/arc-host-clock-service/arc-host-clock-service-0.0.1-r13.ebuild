# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="b733c2848a803e1b9a6fd4a71cf94edf76e98be5"
CROS_WORKON_TREE=("824835433089136b9e63f6cfd441ed8c093fa54c" "86ae26cee95be632aa3f17eef368534853115d55" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
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
	dobin "${OUT}"/arc-host-clock-service

	insinto /etc/init
	doins arc-host-clock-service.conf

	insinto /etc/dbus-1/system.d
	doins org.chromium.ArcHostClockService.conf
}

pkg_preinst() {
	enewuser "arc-host-clock"
	enewgroup "arc-host-clock"
}
