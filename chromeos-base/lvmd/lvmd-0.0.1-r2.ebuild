# Copyright 2022 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="670f99fdd1c56b5c8ac2d93f317f2c742acf74d0"
CROS_WORKON_TREE=("4055d34d682d2a7ff6bc4285499301674c0779ab" "973a58edee991a2e4eaf01bdd098de0acb48ffb6" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_DESTDIR="${S}"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk lvmd .gn"

# This is where BUILD.gn is located.
# For platform2 projects, this indicates that GN should be used to build this
# package.
PLATFORM_SUBDIR="lvmd"

inherit cros-workon platform

DESCRIPTION="A D-Bus service daemon for LVM"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/lvmd/"

LICENSE="BSD-Google"
# Only installs lvmd related binaries/files, so set slotting to 0.
SLOT="0"
KEYWORDS="*"

RDEPEND="sys-fs/lvm2:="
DEPEND="
	${RDEPEND}
	chromeos-base/lvmd-client:=
	chromeos-base/system_api:="

src_install() {
	platform_install
}

platform_pkg_test() {
	platform test_all
}
