# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

CROS_WORKON_COMMIT="e3e55f7439cabd0be7be777295749759551b05fc"
CROS_WORKON_TREE=("c2ef911d0300711ce4127e3c18477ac8a7e70de7" "5bd5bded1012a49d8081a885a2a60f3471c8806a" "dc1506ef7c8cfd2c5ffd1809dac05596ec18773c")
CROS_WORKON_INCREMENTAL_BUILD="1"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk arc/removable-media .gn"

inherit cros-workon

DESCRIPTION="Container to run Android's removable-media daemon."
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/arc/removable-media"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"

RDEPEND="chromeos-base/mount-passthrough
	!<chromeos-base/chromeos-cheets-scripts-0.0.2-r470
"

src_install() {
	insinto /etc/init
	doins arc/removable-media/arc-removable-media.conf
	doins arc/removable-media/arc-removable-media-default.conf
	doins arc/removable-media/arc-removable-media-read.conf
	doins arc/removable-media/arc-removable-media-write.conf
}
