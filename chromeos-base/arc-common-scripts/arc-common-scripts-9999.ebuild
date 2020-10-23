# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

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
KEYWORDS="~*"

IUSE="arcvm arcpp"
RDEPEND="
	!<chromeos-base/arc-setup-0.0.1-r1084
	app-misc/jq"
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
