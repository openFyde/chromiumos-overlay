# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI="6"

CROS_WORKON_COMMIT="8e2838b448d8a58a1fbb55bd98191158a1d5d3f7"
CROS_WORKON_TREE=("4a87f2acd60231694d51adc7faab7765b0a1867b" "2e696fe0d92ccb49431a4aea274853ddfd15f71e" "dc1506ef7c8cfd2c5ffd1809dac05596ec18773c")
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

RDEPEND="
    media-libs/minigbm:=
    x11-libs/libdrm:=
"

DEPEND="
    ${RDEPEND}
    dev-cpp/gtest:=
"

src_install() {
	# Executable files' names take the form graphics.<TestName>.<bin_name>.
	exeinto /usr/libexec/graphics_tests
	doexe "${OUT}"/graphics.*.*
}
