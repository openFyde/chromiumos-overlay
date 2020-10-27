# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="742195408c68ba20769726607e0cb02c174fe71c"
CROS_WORKON_TREE=("824835433089136b9e63f6cfd441ed8c093fa54c" "62ab28cea9982ce45c1ee9b40820f4557f279666" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_INCREMENTAL_BUILD="1"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk arc/scripts .gn"

inherit cros-workon

DESCRIPTION="ARC++ common scripts."
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/arc/scripts"

LICENSE="BSD-Google"
SLOT="0/0"
KEYWORDS="*"

IUSE="arcpp"
RDEPEND="
	!<chromeos-base/arc-setup-0.0.1-r1084
	app-misc/jq"
DEPEND=""

src_install() {
	dosbin arc/scripts/android-sh
	insinto /etc/init
	doins arc/scripts/arc-kmsg-logger.conf
	doins arc/scripts/arc-sensor.conf
	doins arc/scripts/arc-sysctl.conf
	doins arc/scripts/arc-ureadahead.conf
}
