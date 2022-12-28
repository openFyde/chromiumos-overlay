# Copyright 2022 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="d92347efe59230c8b44ecd3213d8c53fd3a4ba43"
CROS_WORKON_TREE=("d12eaa6a060046041408b6cf0c2444c7da2bce2b" "af3f3a28d771a8a1931409072d339f634311c601" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
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

platform_pkg_test() {
	platform test_all
}
