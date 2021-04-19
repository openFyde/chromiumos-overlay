# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI=7
CROS_WORKON_COMMIT="35158d21703140debbbc7d29a8e35312a79c1ce8"
CROS_WORKON_TREE=("c9472e5bf2ef861a0c3b602fb4ae3084a5d96ee8" "3f9bd291ca1a611db3eaaff6cce78f4ebaa0c7eb" "19e57c1cc013e3270ee63a9d8baa567e6a63b163" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_SUBTREE="common-mk bootid-logger croslog .gn"

PLATFORM_SUBDIR="bootid-logger"

inherit cros-workon platform

DESCRIPTION="Program to record the current boot ID to the log"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/bootid-logger"

LICENSE="BSD-Google"
SLOT="0/0"
KEYWORDS="*"
IUSE=""

RDEPEND="!<=chromeos-base/croslog-0.0.1-r44"

src_install() {
	platform_install

	insinto /etc/init
	doins log-bootid-on-boot.conf
}

platform_pkg_test() {
	platform test_all
}

