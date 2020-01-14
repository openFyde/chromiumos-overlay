# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI=7

CROS_WORKON_COMMIT="26ec26c4ac3ba35bf59fa5acbbd26c59a3381adc"
CROS_WORKON_TREE=("65558ff6a3b26d0ace511c80691b2d4c133fa71b" "898687cfd878621b0aa42a27138c8a6c72210b16" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_OUTOFTREE_BUILD="1"
CROS_WORKON_SUBTREE="common-mk secure-wipe .gn"

PLATFORM_SUBDIR="secure-wipe"

inherit cros-workon platform

DESCRIPTION="Secure wipe"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/secure-wipe/"

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE="mmc nvme sata test"

DEPEND=""

RDEPEND="
	app-misc/jq
	sata? ( sys-apps/hdparm )
	mmc? ( sys-apps/mmc-utils )
	nvme? ( sys-apps/nvme-cli )
	sys-apps/util-linux
	sys-block/fio"

src_test() {
	tests/factory_verify_test.sh || die "unittest failed"
}

src_install() {
	dosbin secure-wipe.sh
	dosbin wipe_disk
}
