# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

CROS_WORKON_COMMIT="998d244109b17808a769fa83796ebf0eab6f583a"
CROS_WORKON_TREE=("bf84a23a00350764b97d4ceb2bee5c17164d7855" "3cdd737f49718bc6011f64acbda8c7677853631e" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
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
