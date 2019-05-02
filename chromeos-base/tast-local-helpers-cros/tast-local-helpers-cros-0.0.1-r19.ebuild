# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI="6"

CROS_WORKON_COMMIT=("b5aa13dcc27f0c87b035b3c19f058839b87526f6" "7336349705493045d5139bbea366f1c37be69915")
CROS_WORKON_TREE=("3f7d7bccbeae3471d2d07f6b9475461da31a8e78" "dc1506ef7c8cfd2c5ffd1809dac05596ec18773c" "ce6f7d010c17c544c8ea76e5334e073498262552")
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
