# Copyright 2020 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="1eadd7f2497b44f8e0c7a0731d7acb8e7fd5f486"
CROS_WORKON_TREE=("d12eaa6a060046041408b6cf0c2444c7da2bce2b" "c4345f92f7cb5114a6ba85b5ebeab966befa7dca" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
CROS_WORKON_INCREMENTAL_BUILD="1"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk arc/vm/scripts/init/mount-media-dirs .gn"

inherit cros-workon

DESCRIPTION="Mount media directories on a mount point shared with ARCVM."
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/arc/vm/scripts/init/mount-media-dirs"

LICENSE="BSD-Google"
KEYWORDS="*"

RDEPEND="
	chromeos-base/mount-passthrough
"

src_install() {
	insinto /etc/init
	doins arc/vm/scripts/init/mount-media-dirs/arcvm-mount-myfiles.conf
	doins arc/vm/scripts/init/mount-media-dirs/arcvm-mount-removable-media.conf
}
