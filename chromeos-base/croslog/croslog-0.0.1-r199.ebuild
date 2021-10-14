# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI=7
CROS_WORKON_COMMIT="6ac7c6a1d04a2af191dc52f1256fa10c97e0216b"
CROS_WORKON_TREE=("ef118ceb3e8ebcc8b8a4ae6577a71d7ad210a722" "82a24c84ea7201a1f4e2dc563b180430ae1efa7b" "e08a2eb734e33827dffeecf57eca046cd1091373" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_SUBTREE="common-mk croslog metrics .gn"

PLATFORM_SUBDIR="croslog"

inherit cros-workon platform

DESCRIPTION="Log viewer for Chromium OS"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/croslog"

LICENSE="BSD-Google"
SLOT="0/0"
KEYWORDS="*"
IUSE=""

DEPEND="
	>=chromeos-base/metrics-0.0.1-r3152:=
	"

src_install() {
	platform_install
}

platform_pkg_test() {
	platform test_all
}

