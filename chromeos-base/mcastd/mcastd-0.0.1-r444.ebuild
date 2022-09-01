# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="1f83d6ba0a311c5e4bc574208981d32f0a66660c"
CROS_WORKON_TREE=("da0a96cefc74908f44298f304bea19b64e602847" "14d2839fa75a8cb5545e3795003e4a6d16ad3426" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk patchpanel .gn"

PLATFORM_SUBDIR="patchpanel/mcastd"

inherit cros-workon libchrome platform

DESCRIPTION="Multicast forwarder daemon"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/arc/network/"
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
	platform_install
}
