# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="cecd6fd785374d314497ede07a60ea03697ba46d"
CROS_WORKON_TREE=("113aec10016eaa9629d0db5f3cae59bd9e847a4e" "b42ca8f7a5a99cbbe272658e1ab5dd9d3882b6f8" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
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
