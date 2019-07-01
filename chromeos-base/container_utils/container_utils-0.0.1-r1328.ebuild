# Copyright 2016 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5
CROS_WORKON_COMMIT="069f2a92133ad5b96ec25ee8c150344666b7ebad"
CROS_WORKON_TREE=("3203fc5c38912e1d0625e33126a801b6ae1a0c59" "f8dfa6b9f638e6d0a72e6dcfaffc4157d8f20db5" "dc1506ef7c8cfd2c5ffd1809dac05596ec18773c")
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_SUBTREE="common-mk container_utils .gn"

PLATFORM_SUBDIR="container_utils"

inherit cros-workon platform udev user

DESCRIPTION="Helper utilities for generic containers"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE=""

RDEPEND="
	chromeos-base/libbrillo
	virtual/udev
	sys-fs/fuse
"
DEPEND="
	${RDEPEND}
	chromeos-base/imageloader-client
	chromeos-base/session_manager-client
	chromeos-base/system_api
"

pkg_setup() {
	enewuser "devicejail"
	enewgroup "devicejail"
	cros-workon_pkg_setup
}

src_install() {
	cd "${OUT}"
	dobin device_jail_fs

	fowners devicejail:devicejail /usr/bin/device_jail_fs

	into /usr/local
	dobin device_jail_utility

	cd "${S}"
	insinto /etc/init
	doins device-jail.conf

	udev_dorules udev/*.rules
}

pkg_preinst() {
	enewuser "user-containers"
	enewgroup "user-containers"
}
