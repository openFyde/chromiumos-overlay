# Copyright 2016 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5
CROS_WORKON_COMMIT="ac65f07c0f5bfa07956a90357c0be73b5b2eada0"
CROS_WORKON_TREE=("aa92b41330c5ee79fcd1757aa67b3bda7eec4ea2" "bbadee27086f6da7235f2ea1ec0bc9fe1159162d" "dc1506ef7c8cfd2c5ffd1809dac05596ec18773c")
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

RDEPEND="chromeos-base/libbrillo"
DEPEND="${RDEPEND}"

src_install() {
	dobin "${OUT}"/st_flash
}
