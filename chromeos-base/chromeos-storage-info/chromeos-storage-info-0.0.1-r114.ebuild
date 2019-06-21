# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

CROS_WORKON_COMMIT="793b1832780f148a23b5a71a51758d950403874c"
CROS_WORKON_TREE=("88964300c225b7e8a3c2fe47860d091ca1f4fb65" "8d5d5e575da16bb48f735ef93feedcfae4b1586e" "dc1506ef7c8cfd2c5ffd1809dac05596ec18773c")
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk storage_info .gn"

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
