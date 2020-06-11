# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="d80dcfcab1123bfa1bae9fcebcb08521116644f4"
CROS_WORKON_TREE=("1b35c43f4fc972f1ee5ea532c50eec8765d2af3c" "5b7aadf464ee13a4d5beacc85b0badcbc796821a" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_INCREMENTAL_BUILD="1"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk arc/vm/scripts .gn"

inherit cros-workon

DESCRIPTION="ARCVM common scripts."
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/arc/vm/scripts"

LICENSE="BSD-Google"
KEYWORDS="*"

# Previously this ebuild was named "chromeos-base/arcvm-launch".
# TODO(youkichihosoi): Remove this blocker after a while.
RDEPEND="
	${RDEPEND}
	chromeos-base/arc-setup
	!chromeos-base/arcvm-launch
"

src_install() {
	insinto /etc/init
	doins arc/vm/scripts/init/arcvm-host.conf
	doins arc/vm/scripts/init/arcvm-per-board-features.conf
	doins arc/vm/scripts/init/arcvm-ureadahead.conf

	insinto /usr/share/arcvm
	doins arc/vm/scripts/init/config.json

	insinto /etc/dbus-1/system.d
	doins arc/vm/scripts/init/dbus-1/ArcVmScripts.conf
}
