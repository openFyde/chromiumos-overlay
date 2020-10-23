# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="f1c64ae0bbfc7ae2b3bd779c02081aefd6cc5d66"
CROS_WORKON_TREE=("6cadd9f53ad2c518aa18312d8ea45915a3dd112a" "308a28470686f51374206bb177e0b0ef3299ecfd" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
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
		insinto /etc/init
		doins arc/scripts/arc-kmsg-logger.conf
		doins arc/scripts/arc-sensor.conf
		doins arc/scripts/arc-sysctl.conf
		doins arc/scripts/arc-ureadahead.conf
	fi
	if use arcvm; then
		newsbin arc/scripts/android-sh-vm android-sh
	fi
}
