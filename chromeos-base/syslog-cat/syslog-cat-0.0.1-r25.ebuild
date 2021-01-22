# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI=7
CROS_WORKON_COMMIT="0de749172817084d6c0867f1c9c4ce46b64c7c3d"
CROS_WORKON_TREE=("92fa6c1373050d9593236b88ef883cf2b7d0a85a" "16d74c238bb23c9eb8748c71ac7de8d507e5c55f" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_SUBTREE="common-mk syslog-cat .gn"

PLATFORM_SUBDIR="syslog-cat"

inherit cros-workon platform

DESCRIPTION="Simple command to forward stdout/err to syslog"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/syslog-cat"

LICENSE="BSD-Google"
SLOT="0/0"
KEYWORDS="*"
IUSE=""

src_install() {
	platform_install
}

platform_pkg_test() {
	platform test_all
}

