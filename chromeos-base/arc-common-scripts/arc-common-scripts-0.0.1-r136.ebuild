# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="3c24751e7b54732387b6da5896a990a12a870e65"
CROS_WORKON_TREE=("3f47c000ac2656a574bb06b430a66f6783c3842a" "62ab28cea9982ce45c1ee9b40820f4557f279666" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
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
