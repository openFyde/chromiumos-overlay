# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI="6"

CROS_WORKON_COMMIT=("5b50cee12a654d6d6f84be0efe953913502e2021" "fdd7bb0833bc8b65c404f8126a2d4f948fd3580c")
CROS_WORKON_TREE=("0eec525a4c70ad2279baf610faea66da700238d9" "dc1506ef7c8cfd2c5ffd1809dac05596ec18773c" "ac245d964e43370ed5a9ed6ac4cc6e4b7d10ba47")
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
