# Copyright 2018 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="801e847a3941a1619a53034ccfde1acf49586395"
CROS_WORKON_TREE=("aaaaa3f7d8b4455b36eba6a9874fca10fefb836c" "bc953a063496d992739c1e1c1677cdc102491302" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk storage_info .gn"

PLATFORM_SUBDIR="storage_info"

inherit cros-workon platform

DESCRIPTION="Chrome OS storage info tools"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/storage_info/"
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
	platform_src_install

	insinto /usr/share/misc
	doins share/storage-info-common.sh
}
