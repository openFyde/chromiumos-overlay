# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="9b49062af90a27ae0883516880a40a3b2cfe1c32"
CROS_WORKON_TREE=("d9c21c3b0f24d480773fdba553eb9db4ee252072" "8d5d5e575da16bb48f735ef93feedcfae4b1586e" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk storage_info .gn"

PLATFORM_SUBDIR="storage_info"

inherit cros-workon platform

DESCRIPTION="Chrome OS storage info tools"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/storage_info/"
SRC_URI=""

LICENSE="BSD-Google"
SLOT="0/0"
KEYWORDS="*"
IUSE="mmc nvme +sata test"

DEPEND=""

RDEPEND="${DEPEND}
	chromeos-base/chromeos-common-script
	sata? ( sys-apps/hdparm sys-apps/smartmontools )
	nvme? ( sys-apps/smartmontools )
	mmc? ( sys-apps/mmc-utils )"

platform_pkg_test() {
	platform_test "run" "test/storage_info_unit_test"
}

src_install() {
	insinto /usr/share/misc
	doins share/storage-info-common.sh
}
