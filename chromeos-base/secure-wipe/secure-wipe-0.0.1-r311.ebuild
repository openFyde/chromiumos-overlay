# Copyright 2019 The ChromiumOS Authors
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI=7

CROS_WORKON_COMMIT="eb0846c656180dd81522e64a8fecea93b2322645"
CROS_WORKON_TREE=("e3b92b04b3b4a9c54c71955052636c95b5d2edcd" "79ecdb5d6c1803d91f8fa190dda62410a4aa28ad" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_OUTOFTREE_BUILD="1"
CROS_WORKON_SUBTREE="common-mk secure-wipe .gn"

PLATFORM_SUBDIR="secure-wipe"

inherit cros-workon platform

DESCRIPTION="Secure wipe"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/secure-wipe/"

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE="mmc nvme sata test ufs"

DEPEND=""

RDEPEND="
	app-misc/jq
	sata? ( sys-apps/hdparm )
	mmc? ( sys-apps/mmc-utils )
	nvme? ( sys-apps/nvme-cli )
	ufs? ( chromeos-base/factory_ufs )
	sys-apps/util-linux
	sys-block/fio"

src_test() {
	tests/factory_verify_test.sh || die "unittest failed"
}

src_install() {
	platform_src_install

	dosbin secure-wipe.sh
	dosbin wipe_disk
}
