# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

CROS_WORKON_COMMIT="ea4848dddea32f8b28e02d8d4fea34cad3ae6d45"
CROS_WORKON_TREE=("e220eed9c62e23a855f6b5ebce2310a69a9309a5" "158f6f8b20ae6535461d5b33e793ec853de02599" "dc1506ef7c8cfd2c5ffd1809dac05596ec18773c")
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
