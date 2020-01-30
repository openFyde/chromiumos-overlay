# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="388009cab8aca7ef2eb6652c67fc175fa0cc3326"
CROS_WORKON_TREE=("2ef18d1c42c7aee2c4bb4110359103045c055adf" "6dcd9fca8295bf3dab87c84721b08d3f3aa1ec66" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_INCREMENTAL_BUILD="1"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk arc/scripts .gn"

inherit cros-workon

DESCRIPTION="ARC++/ARCVM common scripts."
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/arc/scripts"

LICENSE="BSD-Google"
SLOT="0/0"
KEYWORDS="*"

IUSE=""
RDEPEND="app-misc/jq"
DEPEND=""

src_install() {
	dosbin arc/scripts/android-sh
	dosbin arc/scripts/android-sh-vm
}
