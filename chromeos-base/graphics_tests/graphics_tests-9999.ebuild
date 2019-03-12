# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI="6"

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
KEYWORDS="~*"

src_install() {
	# Executable files' names take the form graphics.<TestName>.<bin_name>.
	exeinto /usr/libexec/graphics_tests
	doexe "${OUT}"/graphics.*.*
}
