# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

CROS_WORKON_COMMIT="a543dc6fed8a5bf2479177c116e0137274db3533"
CROS_WORKON_TREE=("3203fc5c38912e1d0625e33126a801b6ae1a0c59" "1b35eda182ce4c7ac6c53c4572b748d29782dbfb" "dc1506ef7c8cfd2c5ffd1809dac05596ec18773c")
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
