# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="e2c31be2c6dea118b5f77bc9ec1f4f470abdf6e2"
CROS_WORKON_TREE=("a54d2df3e8853d5a5f1e0854b36d8d850db3611e" "954e934fa76d67253d978d97346b24a1fce9be2c" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_INCREMENTAL_BUILD="1"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk arc/vm/scripts/init/mount-media-dirs .gn"

inherit cros-workon

DESCRIPTION="Mount media directories on a mount point shared with ARCVM."
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/arc/vm/scripts/init/mount-media-dirs"

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
