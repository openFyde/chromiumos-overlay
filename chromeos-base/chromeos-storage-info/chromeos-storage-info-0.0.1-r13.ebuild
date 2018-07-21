# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

CROS_WORKON_COMMIT="b50be1aced4254e00a9ed3d29a8225e3a59d7b5e"
CROS_WORKON_TREE=("a2a07ac014916b11c1524d9c49deb705d7ef3231" "06e5571f391ba02bfce58ae1a3c913b2691a160d")
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk storage_info"

PLATFORM_SUBDIR="storage_info"

inherit cros-workon platform

DESCRIPTION="Chrome OS storage info tools"
HOMEPAGE="http://www.chromium.org/"
SRC_URI=""

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE="+mmc nvme +sata test"

DEPEND=""

RDEPEND="${DEPEND}
	chromeos-base/chromeos-common-script
	!<chromeos-base/chromeos-installer-0.0.3
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
