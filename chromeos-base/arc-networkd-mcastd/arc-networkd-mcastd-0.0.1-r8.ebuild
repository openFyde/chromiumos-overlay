# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="2908049eaabcd78c39010138a509f85c51f1ebfc"
CROS_WORKON_TREE=("dea48af07754556aac092c0830de0b1ab410077b" "989fc5b68d9051a0a993eed51f588d69ccc2002b" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
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
