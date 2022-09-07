# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="acdfde7caf3219642a76adc62cac4ae3f4dd102a"
CROS_WORKON_TREE=("91b05f82aaed4608264d4ca378e9b6c7556eedfb" "bbef155ccb62bc239a608059ccbd2f3f7d7e93a3" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_INCREMENTAL_BUILD="1"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk arc/container/myfiles .gn"

inherit cros-workon

DESCRIPTION="Container to run Android's MyFiles daemon."
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/arc/container/myfiles"

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
