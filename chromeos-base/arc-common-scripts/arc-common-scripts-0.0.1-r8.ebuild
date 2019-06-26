# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

CROS_WORKON_COMMIT="04d44dead916a72d106cc8c0626e793210c1b9dd"
CROS_WORKON_TREE=("85e0104104aae2c94fdb541e99b3e41c2d472eef" "403d2ea2e144eb63f2be80876797a8a7bc9d8238" "dc1506ef7c8cfd2c5ffd1809dac05596ec18773c")
CROS_WORKON_INCREMENTAL_BUILD="1"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk arc/scripts .gn"

inherit cros-workon

DESCRIPTION="ARC++/ARCVM common scripts."
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/arc/scripts"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"

IUSE=""
RDEPEND="app-misc/jq"
DEPEND="${RDEPEND}"

src_install() {
	dosbin arc/scripts/android-sh
	dosbin arc/scripts/android-sh-vm
}
