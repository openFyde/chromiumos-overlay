# Copyright 2016 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5
CROS_WORKON_COMMIT="fda7723bb7a45184ab59d6f6ec0eed96d1264477"
CROS_WORKON_TREE=("b6b10e03115551b69ba9e2502b15d5467adcd107" "08e4ed1fd14e116ece76a1d493ace5b137f4c360" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
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
