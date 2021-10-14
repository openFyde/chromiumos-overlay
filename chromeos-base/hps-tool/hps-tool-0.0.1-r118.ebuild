# Copyright 2021 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="5a1edcb607112349dd4843a28f9cd0cf9cf36a95"
CROS_WORKON_TREE=("ef118ceb3e8ebcc8b8a4ae6577a71d7ad210a722" "25eaa825e28490ffbbcce9388b6edb09ae663790" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb" "e08a2eb734e33827dffeecf57eca046cd1091373")
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
	dev-libs/libusb:=
	dev-embedded/libftdi:=
	chromeos-base/metrics:=
	"

RDEPEND="${COMMON_DEPEND}"

DEPEND="
	${COMMON_DEPEND}
	"

src_install() {
	dobin "${OUT}"/hps
}
