# Copyright 2020 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="569acd1eb0e5ee39f1e4b50921a0856c0b30f137"
CROS_WORKON_TREE=("0c3a30cd50ce72094fbd880f2d16d449139646a2" "ac4c721d9100afb23dff083a9c12d9e50a7e9b08" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
CROS_WORKON_INCREMENTAL_BUILD="1"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk arc/vm/scripts/init/mount-media-dirs .gn"

inherit cros-workon

DESCRIPTION="Mount media directories on a mount point shared with ARCVM."
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/arc/vm/scripts/init/mount-media-dirs"

LICENSE="BSD-Google"
KEYWORDS="*"

RDEPEND="
	chromeos-base/mount-passthrough
"

src_install() {
	insinto /etc/init
	doins arc/vm/scripts/init/mount-media-dirs/arcvm-mount-myfiles.conf
	doins arc/vm/scripts/init/mount-media-dirs/arcvm-mount-play-files.conf
	doins arc/vm/scripts/init/mount-media-dirs/arcvm-mount-removable-media.conf
	doins arc/vm/scripts/init/mount-media-dirs/arcvm-mount-sdcard-dir.conf
}
