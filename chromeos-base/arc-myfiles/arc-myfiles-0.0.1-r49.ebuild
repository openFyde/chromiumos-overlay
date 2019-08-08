# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

CROS_WORKON_COMMIT="8bd1042f66b665c37ca24cec2f7c0908bff56a5f"
CROS_WORKON_TREE=("ce312a57a100a69f5e2d0f8f445e1f6c7604fc95" "03dfb274aff1b585b0aae196f76ee08957ee3842" "dc1506ef7c8cfd2c5ffd1809dac05596ec18773c")
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
