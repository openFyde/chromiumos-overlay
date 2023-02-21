# Copyright 2020 The ChromiumOS Authors
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI=7
CROS_WORKON_COMMIT="db50fe0ee6a2e2756fd40d261155c240548ad26b"
CROS_WORKON_TREE=("92a7718bfe5a15c594fcc6b0855e68b0981cd9a0" "20515ed7d22d24b8029a66e6330f6ab99c2ff3ac" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_SUBTREE="common-mk syslog-cat .gn"

PLATFORM_SUBDIR="syslog-cat"

inherit cros-workon platform

DESCRIPTION="Simple command to forward stdout/err to syslog"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/syslog-cat"

LICENSE="BSD-Google"
SLOT="0/0"
KEYWORDS="*"
IUSE=""

platform_pkg_test() {
	platform test_all
}
