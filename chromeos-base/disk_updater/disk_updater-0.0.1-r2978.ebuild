# Copyright (c) 2013 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="7"
CROS_WORKON_COMMIT="cc1d8ccde6295dbc2a519307383dc72da01875d4"
CROS_WORKON_TREE=("ad301a4b345fce6b7da1833dbc8976b38360b43f" "a84edaa470edc69e27335f718e4784a8fcc883f9" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk disk_updater .gn"

PLATFORM_SUBDIR="disk_updater"

inherit cros-workon platform

DESCRIPTION="Root disk firmware updater"
HOMEPAGE="http://www.chromium.org/"
SRC_URI=""

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE="+sata mmc nvme"

DEPEND=""

RDEPEND="${DEPEND}
	chromeos-base/chromeos-common-script
	sata? ( sys-apps/hdparm )
	mmc? ( sys-apps/mmc-utils )
	nvme? ( sys-apps/nvme-cli )"

platform_pkg_test() {
	# We can test all, even if mmc or nvme are not installed.
	local tests=( 'ata' 'mmc' 'nvme')

	local test_type
	for test_type in "${tests[@]}"; do
		platform_test "run" "tests/chromeos-disk-firmware-${test_type}-test.sh"
	done
}

src_install() {
	insinto "/etc/init"
	doins "scripts/chromeos-disk-firmware-update.conf"

	dosbin "scripts/chromeos-disk-firmware-update.sh"
}
