# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

CROS_WORKON_COMMIT="0e19589f0c5625d36f6f6c54731cb4a66424e279"
CROS_WORKON_TREE=("fd02e6090c8f07ce200c4a4a20eefc55a064dc6d" "3847c10e4808ca72818b04338063ea0b5ac738c2" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_INCREMENTAL_BUILD="1"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk arc/vm/launch .gn"

PLATFORM_SUBDIR="arc/vm/launch"

inherit cros-workon platform

DESCRIPTION="A package to run arcvm."
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/arc/vm/launch"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"

RDEPEND="
	chromeos-base/libbrillo:=
	chromeos-base/vboot_reference:=
	dev-libs/protobuf:=
"

DEPEND="
	${RDEPEND}
	chromeos-base/system_api:=
"

# Previously this ebuild was named "arcvm".
# TODO(hashimoto): Remove this blocker after a while.
RDEPEND="
	${RDEPEND}
	!chromeos-base/arcvm
"

src_install() {
	dobin "${OUT}"/arcvm-launch

	insinto /etc/init
	doins init/arcvm.conf
	doins init/arcvm-ureadahead.conf

	insinto /etc/dbus-1/system.d
	doins init/dbus-1/ArcVmUpstart.conf
}
