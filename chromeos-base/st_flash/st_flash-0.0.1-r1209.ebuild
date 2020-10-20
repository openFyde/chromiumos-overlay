# Copyright 2016 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5
CROS_WORKON_COMMIT="2a2b0046d672cce8f7f715913f96498a1b27784c"
CROS_WORKON_TREE=("55c3467f43d24a0d99c27d8e9e417502a8aecede" "ffebcde7bf67275f78bf7dcb24753a1cfacc3e30" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_INCREMENTAL_BUILD="1"
CROS_WORKON_SUBTREE="common-mk st_flash .gn"

PLATFORM_SUBDIR="st_flash"

inherit cros-workon platform

DESCRIPTION="STM32 IAP firmware updater for Chrome OS touchpads"
HOMEPAGE=""

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE=""

src_install() {
	dobin "${OUT}"/st_flash
}
