# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="bc5ebb29696e378f26737133bb4bd471bd96ceb0"
CROS_WORKON_TREE=("e878c3ec9ca8c15b6f63f45f4c95e8aaa646f0ad" "16dee0336113553f488cfba1cd0cd13b84b8870f" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
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
