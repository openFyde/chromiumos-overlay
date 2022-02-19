# Copyright 2021 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="d2a4b03debf66a6257a63d233138c70bdc1b8855"
CROS_WORKON_TREE=("a1485b27500f3f8a7cf4204d77b152d1c173e313" "514a8257c9af63687e756fb30f05bb56c9dc76c6" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb" "6c62976d54d7f97f7fdf322dd9c086afaa321925")
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
