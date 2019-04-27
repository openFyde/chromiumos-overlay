# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI="6"

CROS_WORKON_COMMIT=("66611f9d81eba5f3d61d8ff62c1bf3233ccb80e9" "98ac1394baf5edb79bc90361b9ebef8c85528698")
CROS_WORKON_TREE=("2f72a5edb8d5f40c8d31f932ebcbcc7452a30492" "dc1506ef7c8cfd2c5ffd1809dac05596ec18773c" "47e9e3a58085b8cfd36b4148d98307f607102b40")
CROS_WORKON_PROJECT=("chromiumos/platform2" "chromiumos/platform/tast-tests")
CROS_WORKON_LOCALNAME=("platform2" "platform/tast-tests")
CROS_WORKON_DESTDIR=("${S}/platform2" "${S}/platform2/tast-tests")
CROS_WORKON_SUBTREE=("common-mk .gn" "helpers")

PLATFORM_SUBDIR="tast-tests/helpers/local"

inherit cros-workon platform

DESCRIPTION="Compiled executables used by local Tast tests in the cros bundle"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform/tast-tests/+/master/helpers"

LICENSE="BSD-Google GPL-3"
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
	# Executable files' names take the form <category>.<TestName>.<bin_name>.
	exeinto /usr/libexec/tast/helpers/local/cros
	doexe "${OUT}"/*.[A-Z]*.*
}
