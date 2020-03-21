# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="c90aa6f17dcbdeaf4e7c5ce155f3a685afdbfd01"
CROS_WORKON_TREE=("6efa0db0e49014be7389d66af98ab7469b93fc60" "94ebfcee6244d649c72ae5ac6129738a6fc1b47c" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk arc/network .gn"

PLATFORM_SUBDIR="arc/network/mcastd"

inherit cros-workon libchrome platform

DESCRIPTION="Multicast forwarder daemon"
HOMEPAGE="http://www.chromium.org/"
LICENSE="BSD-Google"
KEYWORDS="*"

COMMON_DEPEND="
	dev-libs/protobuf:=
	chromeos-base/libbrillo:=
"

RDEPEND="
	${COMMON_DEPEND}
"

DEPEND="
	${COMMON_DEPEND}
"

src_install() {
	dobin "${OUT}"/mcastd
}
