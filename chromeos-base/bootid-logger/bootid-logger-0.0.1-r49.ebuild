# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI=7
CROS_WORKON_COMMIT="6de9fb56cd2a3435eade3d87a97d49a3f995e718"
CROS_WORKON_TREE=("ae528dee9890ab7346a1fee2e50877007ea3e1c0" "3f9bd291ca1a611db3eaaff6cce78f4ebaa0c7eb" "2c06a5e02d00f3962cc6b841727daecfff0e4ae3" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
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

