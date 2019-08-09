# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI="6"

CROS_WORKON_COMMIT="f8e07dae2ad8c152a76d7c76e3cbf9cf2471dcfb"
CROS_WORKON_TREE=("34ec149bfffef93be14397dd8372e9c1bdbe7bfe" "b680a44233b05e974aa54bc836b7320189bfd20f" "dc1506ef7c8cfd2c5ffd1809dac05596ec18773c")
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_OUTOFTREE_BUILD="1"
CROS_WORKON_SUBTREE="common-mk secure-wipe .gn"

PLATFORM_SUBDIR="secure-wipe"

inherit cros-workon platform

DESCRIPTION="Secure wipe"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/secure-wipe/"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE="mmc nvme sata test"

DEPEND=""

RDEPEND="
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
}
