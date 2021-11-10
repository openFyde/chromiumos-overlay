# Copyright 2021 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="d4ee1fe06a47fe9152ac06a81f72ea50dc21f2fb"
CROS_WORKON_TREE=("dd5deba53d49ed330f1ab8e59f845daae76650c8" "d86e34e22b8bc6de379018821c7680bef61e5b5c" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb" "84b5577206ba4849f4c3ad3e00cec4549e48eaca")
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
	dev-libs/libgpiod:=
	dev-libs/libusb:=
	dev-embedded/libftdi:=
	chromeos-base/metrics:=
	"

RDEPEND="${COMMON_DEPEND}"

DEPEND="
	${COMMON_DEPEND}
	"

src_install() {
	platform_src_install

	dobin "${OUT}"/hps
}
