# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="09ab135e93f822456620fa4f971bf0944d16c7d9"
CROS_WORKON_TREE=("aa3037cba4240557bc815849a7cc258f1d6ae779" "ff71a1d5b2e97314d70c278ab4bd60a5b56830fd" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
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
