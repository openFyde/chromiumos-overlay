# Copyright 2021 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="ab19e478567b9adead327ae57245c729551cf400"
CROS_WORKON_TREE=("6aa4b259533027a10db1d4f89ed4cf9fbc0b65a2" "c3a57c28e0649279b17719de5ea83ad5cf5765bc" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb" "4a0dedab080195bdc122d2289118df4af3ddca2c")
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_SUBTREE="common-mk hps .gn metrics"

PLATFORM_SUBDIR="hps/util"

inherit cros-workon platform

DESCRIPTION="HPS utilities and tool"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/main/hps"

LICENSE="BSD-Google"
SLOT="0/0"
KEYWORDS="*"

COMMON_DEPEND="
	chromeos-base/metrics:=
	virtual/libusb:1
	"

RDEPEND="${COMMON_DEPEND}"

DEPEND="${COMMON_DEPEND}"

src_install() {
	platform_src_install

	dobin "${OUT}"/hps
}
