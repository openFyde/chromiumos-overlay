# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="00c1c357241e7f6363f556fdb0d2cf2386347008"
CROS_WORKON_TREE=("e2a3a6742f6acdc76df13145ab31b6471243d736" "d3893407ccc92f4df8b76269a7110c695635da77" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
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
