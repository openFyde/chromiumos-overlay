# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="09c5bc2d23a4e625fdd74032e385e630e9caa0bb"
CROS_WORKON_TREE=("e7f63c823468db13a24ebe2323042c054c4316c9" "52a8dfd1ecf17b48fee49f656fc032c0fab03760" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
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
