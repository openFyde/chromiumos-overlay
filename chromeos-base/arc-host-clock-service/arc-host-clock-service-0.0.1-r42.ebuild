# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="d7d02e3d3be256c2f8a276083494cb73428fa44f"
CROS_WORKON_TREE=("c23e9bd8eaa54cbd599b1a7aca04009fd33af563" "d5ebac6b78340ae031e643c6ddb2afdb32017e76" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
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
}

pkg_preinst() {
	enewuser "arc-host-clock"
	enewgroup "arc-host-clock"
}
