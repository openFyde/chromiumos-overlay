# Copyright (c) 2011 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="f34cf3a06f7b17b7829185630d886a5d9d3f0e75"
CROS_WORKON_TREE=("791c6808b4f4f5f1c484108d66ff958d65f8f1e3" "27ef0d6acd54bc79665263fb561d89abb458d867" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_DESTDIR="${S}"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk modem-utilities .gn"

PLATFORM_SUBDIR="modem-utilities"

inherit cros-workon tmpfiles platform

DESCRIPTION="Chromium OS modem utilities"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/modem-utilities/"
SRC_URI=""
LICENSE="BSD-Google"
KEYWORDS="*"

COMMON_DEPEND="
	sys-apps/dbus:=
"
RDEPEND="${COMMON_DEPEND}"
DEPEND="${COMMON_DEPEND}"

src_install() {
	dobin modem
	dobin connectivity
	dobin config_net_log

	exeinto /usr/lib
	doexe modem-common.sh
	doexe connectivity-common.sh

	dotmpfiles tmpfiles.d/*.conf
}
