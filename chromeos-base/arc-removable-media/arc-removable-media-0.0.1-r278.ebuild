# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="767435cd6f0f56513261a9c1944e8b9fac3d4833"
CROS_WORKON_TREE=("4e8375d2227f9909b5c713730a4a50d7d3b055bb" "04895b2742e35f6f113e6f31ded261151f13bf57" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_INCREMENTAL_BUILD="1"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk arc/container/removable-media .gn"

inherit cros-workon

DESCRIPTION="Container to run Android's removable-media daemon."
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/arc/container/removable-media"

LICENSE="BSD-Google"
KEYWORDS="*"

RDEPEND="chromeos-base/mount-passthrough
	!<chromeos-base/chromeos-cheets-scripts-0.0.2-r470
"

src_install() {
	insinto /etc/init
	doins arc/container/removable-media/arc-removable-media.conf
	doins arc/container/removable-media/arc-removable-media-default.conf
	doins arc/container/removable-media/arc-removable-media-read.conf
	doins arc/container/removable-media/arc-removable-media-write.conf
}
