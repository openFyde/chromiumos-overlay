# Copyright 2021 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="4fa0d173c3d72ca8daf1085c705fdc19923f6756"
CROS_WORKON_TREE=("ba51cdbc1f93611f21a434aa8577a98ed1e9d5f8" "fca72a5d79615be88881d348c2b56560c3ff32b6" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb" "7dbb54592f1dadb985c773aeec05a36323703d2f")
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
