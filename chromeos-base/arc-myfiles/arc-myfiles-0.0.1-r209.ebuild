# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="4d099cee2590cde0d0fc8e580f1ad4e376e028d9"
CROS_WORKON_TREE=("39f1a7f0ec7c21bbbd48ca4dc192213b5fd7e5f1" "c8a2550e2697f391dc686b4a72841d4568a5de73" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_INCREMENTAL_BUILD="1"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk arc/container/myfiles .gn"

inherit cros-workon

DESCRIPTION="Container to run Android's MyFiles daemon."
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/arc/container/myfiles"

LICENSE="BSD-Google"
KEYWORDS="*"

RDEPEND="chromeos-base/mount-passthrough
	!<chromeos-base/chromeos-cheets-scripts-0.0.2-r470
"

src_install() {
	insinto /etc/init
	doins arc/container/myfiles/arc-myfiles.conf
	doins arc/container/myfiles/arc-myfiles-default.conf
	doins arc/container/myfiles/arc-myfiles-read.conf
	doins arc/container/myfiles/arc-myfiles-write.conf
}
