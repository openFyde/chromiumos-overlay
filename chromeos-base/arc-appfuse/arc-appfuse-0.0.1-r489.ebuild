# Copyright 2018 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="db50fe0ee6a2e2756fd40d261155c240548ad26b"
CROS_WORKON_TREE=("92a7718bfe5a15c594fcc6b0855e68b0981cd9a0" "0f947fd0f88242afb569b16946a6830dda81bd09" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
CROS_WORKON_INCREMENTAL_BUILD="1"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk arc/container/appfuse .gn"

PLATFORM_SUBDIR="arc/container/appfuse"

inherit cros-workon platform user

DESCRIPTION="D-Bus service to provide ARC Appfuse"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/arc/container/appfuse"

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

pkg_preinst() {
	enewuser "arc-appfuse-provider"
	enewgroup "arc-appfuse-provider"
}

platform_pkg_test() {
	platform test_all
}
