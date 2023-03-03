# Copyright 2019 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="a7abf7d575d2512c685f8fa5fc623f14ae254b02"
CROS_WORKON_TREE=("1b5ebc521941b7ffcb2e3013d5d47bcaf804cf86" "10d13347bb70344e10e1103d89366094ef119209" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
CROS_WORKON_INCREMENTAL_BUILD="1"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk arc/container/scripts .gn"

inherit cros-workon

DESCRIPTION="ARC++ common scripts."
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/arc/container/scripts"

LICENSE="BSD-Google"
SLOT="0/0"
KEYWORDS="*"

IUSE="arcpp"
RDEPEND="
	!<=chromeos-base/arc-base-0.0.1-r349
	!<chromeos-base/arc-setup-0.0.1-r1084
	app-misc/jq"
DEPEND=""

src_install() {
	dosbin arc/container/scripts/android-sh
	insinto /etc/init
	doins arc/container/scripts/arc-kmsg-logger.conf
	doins arc/container/scripts/arc-ureadahead.conf
	insinto /etc/sysctl.d
	doins arc/container/scripts/01-sysctl-arc.conf
	# Redirect ARC logs to arc.log.
	insinto /etc/rsyslog.d
	doins arc/container/scripts/rsyslog.arc.conf
}
