# Copyright 2013 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"
CROS_WORKON_COMMIT="95cba42c3e39999a02c3534e6924cdd5b8cdc775"
CROS_WORKON_TREE=("79cdd007ff69259efcaad08803ef2d1498374ec4" "3e792f20bd9f714b6d25305b8e7c79b9a6966e65" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk disk_updater .gn"

PLATFORM_SUBDIR="disk_updater"

inherit cros-workon platform

DESCRIPTION="Root disk firmware updater"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/disk_updater/"
SRC_URI=""

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE="+sata mmc nvme"

DEPEND="
	test? (
		sys-apps/diffutils
	)
"

RDEPEND="
	chromeos-base/chromeos-common-script
	dev-util/shflags
	sata? ( sys-apps/hdparm )
	mmc? ( sys-apps/mmc-utils )
	nvme? ( sys-apps/nvme-cli )
"

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
