# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="f31794e5d46e95e3c3c5e0080053e1c0fa3d4ee0"
CROS_WORKON_TREE=("27d7d5f2d4de786738c22f9ded288cce7eed6a7c" "779ec3953795906d5332af775107bc8d613f1627" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_INCREMENTAL_BUILD="1"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk arc/myfiles .gn"

inherit cros-workon

DESCRIPTION="Container to run Android's MyFiles daemon."
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/arc/myfiles"

LICENSE="BSD-Google"
KEYWORDS="*"

RDEPEND="chromeos-base/mount-passthrough
	!<chromeos-base/chromeos-cheets-scripts-0.0.2-r470
"

src_install() {
	insinto /etc/init
	doins arc/myfiles/arc-myfiles.conf
	doins arc/myfiles/arc-myfiles-default.conf
	doins arc/myfiles/arc-myfiles-read.conf
	doins arc/myfiles/arc-myfiles-write.conf
}
