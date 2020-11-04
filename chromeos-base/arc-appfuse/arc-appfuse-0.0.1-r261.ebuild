# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="954d3c5af0e3fb84c003213beee7bdf166373fe4"
CROS_WORKON_TREE=("abc7e8d3093049ed5a5825a5630870b13d1ad4d2" "6fc1251278d823572e22339c6d140ded0702f3af" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_INCREMENTAL_BUILD="1"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk arc/container/appfuse .gn"

PLATFORM_SUBDIR="arc/container/appfuse"

inherit cros-workon platform user

DESCRIPTION="D-Bus service to provide ARC Appfuse"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/arc/container/appfuse"

LICENSE="BSD-Google"
KEYWORDS="*"

RDEPEND="
	sys-apps/dbus:=
	sys-fs/fuse:=
"

DEPEND="${RDEPEND}
	chromeos-base/system_api:=
"

BDEPEND="
	virtual/pkgconfig
"

src_install() {
	platform_install
}

pkg_preinst() {
	enewuser "arc-appfuse-provider"
	enewgroup "arc-appfuse-provider"
}

platform_pkg_test() {
	platform test_all
}
