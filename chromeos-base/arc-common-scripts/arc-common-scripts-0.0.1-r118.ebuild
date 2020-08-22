# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="300292b66ec823232b046d9ee4fb24a5fc7d98fc"
CROS_WORKON_TREE=("a18be0e4067223084eb001e588d475448d48cd4c" "e854d2326138b30cc4e6f04570f2c8f50e2dfa80" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
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

IUSE="arcvm arcpp"
RDEPEND="app-misc/jq"
DEPEND=""

src_install() {
	if use arcpp; then
		dosbin arc/scripts/android-sh
	fi
	if use arcvm; then
		newsbin arc/scripts/android-sh-vm android-sh
	fi

	insinto /etc/init
	doins arc/scripts/arc-remove-data.conf
	doins arc/scripts/arc-stale-directory-remover.conf
}
