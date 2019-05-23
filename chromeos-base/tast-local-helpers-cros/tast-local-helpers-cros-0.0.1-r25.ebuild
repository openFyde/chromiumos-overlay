# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI="6"

CROS_WORKON_COMMIT=("f64c1749b81099c31822e6c99d229a1e250a8d5b" "46a884a75990407e17ead066f66196c87b945ce1")
CROS_WORKON_TREE=("11f584bb7dd3244e1eec145f7e377b32b68e8b3b" "dc1506ef7c8cfd2c5ffd1809dac05596ec18773c" "5db60d314fab568dafa2bf67e58dd101e923f2a6")
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
