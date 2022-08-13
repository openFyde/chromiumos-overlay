# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="d640cf36c1cb7d5b90023f4fb26b476a41d26b6f"
CROS_WORKON_TREE=("5ce03b99f33d64f242f02a09dcf165bdbad8d7d4" "52a8dfd1ecf17b48fee49f656fc032c0fab03760" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
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
