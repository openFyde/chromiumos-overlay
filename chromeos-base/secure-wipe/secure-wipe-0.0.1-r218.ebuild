# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI=7

CROS_WORKON_COMMIT="2a46a98f96ec6af1b6f71f0579284e78f254cb1f"
CROS_WORKON_TREE=("32b4e8dd008b53110288d6ab187104a92b405c89" "898687cfd878621b0aa42a27138c8a6c72210b16" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
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
