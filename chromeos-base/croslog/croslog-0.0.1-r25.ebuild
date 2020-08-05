# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI=7
CROS_WORKON_COMMIT="f8d0f6ce00239e339c164c792481e996d3948ee1"
CROS_WORKON_TREE=("638bfde957a502ad58d182712c1ebdf335f9a3da" "4a405e81fdc16be783112a898ac461d8efeb0017" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_SUBTREE="common-mk croslog .gn"

PLATFORM_SUBDIR="croslog"

inherit cros-workon platform

DESCRIPTION="Log viewer for Chromium OS"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/croslog"

LICENSE="BSD-Google"
SLOT="0/0"
KEYWORDS="*"
IUSE=""

src_install() {
	platform_install

	insinto /etc/init
	doins etc/log-bootid-on-boot.conf
}

platform_pkg_test() {
	platform test_all
}

