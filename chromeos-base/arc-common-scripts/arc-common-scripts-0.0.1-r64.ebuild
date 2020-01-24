# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="47c7f847879bc350067d4eda4038d1151cc0abc2"
CROS_WORKON_TREE=("e27f1b4637c4d92b0c7b14963d2910ad6b0b631e" "6dcd9fca8295bf3dab87c84721b08d3f3aa1ec66" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
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
