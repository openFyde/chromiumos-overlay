# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="a25092f7721cab5ed73550232ead248bc78c2e52"
CROS_WORKON_TREE=("9ab77225a799145c1011d187b3274f5291d5ca7e" "434170aa6f4b0783eb80a76648f8e27f71b420fd" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_INCREMENTAL_BUILD="1"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk arc/container/scripts .gn"

inherit cros-workon

DESCRIPTION="ARC++ common scripts."
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/arc/container/scripts"

LICENSE="BSD-Google"
SLOT="0/0"
KEYWORDS="*"

IUSE="arcpp iioservice"
RDEPEND="
	!<=chromeos-base/arc-base-0.0.1-r349
	!<chromeos-base/arc-setup-0.0.1-r1084
	app-misc/jq"
DEPEND=""

src_install() {
	dosbin arc/container/scripts/android-sh
	insinto /etc/init
	doins arc/container/scripts/arc-kmsg-logger.conf
	use iioservice || doins arc/container/scripts/arc-sensor.conf
	doins arc/container/scripts/arc-ureadahead.conf
	insinto /etc/sysctl.d
	doins arc/container/scripts/01-sysctl-arc.conf
	# Redirect ARC logs to arc.log.
	insinto /etc/rsyslog.d
	doins arc/container/scripts/rsyslog.arc.conf
}
