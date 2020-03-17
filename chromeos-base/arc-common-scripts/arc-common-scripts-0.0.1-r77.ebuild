# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="2c9f5f4dbbe7ab2e788961194484d975cbb9380f"
CROS_WORKON_TREE=("94bdce168a00f19903b3dd162e8e755cee9bbbf8" "6c41df94d96c7a66b827eef58b0b2b5a22e21643" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
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

	insinto /etc/init
	doins arc/scripts/arc-remove-data.conf
	doins arc/scripts/arc-stale-directory-remover.conf
}
