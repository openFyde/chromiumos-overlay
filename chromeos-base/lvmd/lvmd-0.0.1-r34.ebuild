# Copyright 2022 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="a855bb228d4c90a155e7e55b59ee2deea2092f0a"
CROS_WORKON_TREE=("c1fccf769cca034a27f9f4ad245e2b09a5d66ba6" "ce84baf98e58eae6fdd4ea2a1dd539ced96f9c6b" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
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
