# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI=7
CROS_WORKON_COMMIT="93201e7512fe82e8fccdec5b7c05956571e2f43c"
CROS_WORKON_TREE=("49ec0cc074e4fe5ad441f01547361a8f211118fa" "5cbb3b50e94cd190817a813ffb446c07cde6990b" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
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

