# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI="6"

CROS_WORKON_COMMIT=("c817e80e0835cf8974932213efb8dd66ad46a947" "3108a1ae179a2545d41664eb46539b828e766d04")
CROS_WORKON_TREE=("f20ef95ef82c9a0c0b9587bf625efc621a908489" "dc1506ef7c8cfd2c5ffd1809dac05596ec18773c" "5db60d314fab568dafa2bf67e58dd101e923f2a6")
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
