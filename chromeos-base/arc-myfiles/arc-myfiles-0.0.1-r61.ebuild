# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

CROS_WORKON_COMMIT="c6e430949b7789fd1155da1ce6451cc5c30f2555"
CROS_WORKON_TREE=("3ec7544c4b108a15d3ea61facc0a4bbeace58eed" "03dfb274aff1b585b0aae196f76ee08957ee3842" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_INCREMENTAL_BUILD="1"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk arc/myfiles .gn"

inherit cros-workon

DESCRIPTION="Container to run Android's MyFiles daemon."
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/arc/myfiles"

LICENSE="BSD-Google"
SLOT="0"
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
