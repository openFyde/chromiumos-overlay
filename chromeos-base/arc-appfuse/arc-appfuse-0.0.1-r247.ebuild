# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="d220427c70327dc24b7251466bf1b01a6e2b29e4"
CROS_WORKON_TREE=("e878c3ec9ca8c15b6f63f45f4c95e8aaa646f0ad" "c8c2c74c9c7c509d1151cf979a1a9127d566d04b" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_INCREMENTAL_BUILD="1"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk arc/appfuse .gn"

PLATFORM_SUBDIR="arc/appfuse"

inherit cros-workon platform user

DESCRIPTION="D-Bus service to provide ARC Appfuse"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/arc/appfuse"

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
