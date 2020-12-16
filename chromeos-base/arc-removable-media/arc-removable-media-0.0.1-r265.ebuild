# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="b05e4a6b92b2cfe608b6cd8d5d37168680fc080e"
CROS_WORKON_TREE=("52a8a8b6d3bbca5e90d4761aa308a5541d52b1bb" "2fd3846666a234d4f8f558b916cd2b4c270e8d54" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_INCREMENTAL_BUILD="1"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk arc/container/removable-media .gn"

inherit cros-workon

DESCRIPTION="Container to run Android's removable-media daemon."
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/arc/container/removable-media"

LICENSE="BSD-Google"
KEYWORDS="*"

RDEPEND="chromeos-base/mount-passthrough
	!<chromeos-base/chromeos-cheets-scripts-0.0.2-r470
"

src_install() {
	insinto /etc/init
	doins arc/container/removable-media/arc-removable-media.conf
	doins arc/container/removable-media/arc-removable-media-default.conf
	doins arc/container/removable-media/arc-removable-media-read.conf
	doins arc/container/removable-media/arc-removable-media-write.conf
}
