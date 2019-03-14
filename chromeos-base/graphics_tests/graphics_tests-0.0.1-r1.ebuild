# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI="6"

CROS_WORKON_COMMIT="8cefdea59f5c95e73bd6cfee3e386e9dddec2daa"
CROS_WORKON_TREE=("e220eed9c62e23a855f6b5ebce2310a69a9309a5" "2e696fe0d92ccb49431a4aea274853ddfd15f71e" "dc1506ef7c8cfd2c5ffd1809dac05596ec18773c")
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk graphics_tests .gn"

PLATFORM_SUBDIR="graphics_tests"

inherit cros-workon platform

DESCRIPTION="Compiled executables used by Tast graphics tests"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/graphics_tests"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"

src_install() {
	# Executable files' names take the form graphics.<TestName>.<bin_name>.
	exeinto /usr/libexec/graphics_tests
	doexe "${OUT}"/graphics.*.*
}
