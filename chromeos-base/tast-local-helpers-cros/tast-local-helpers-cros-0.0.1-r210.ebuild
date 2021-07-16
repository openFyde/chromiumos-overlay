# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI=7

CROS_WORKON_COMMIT=("9eb30f9bd7ea687b61411060d3e70c8b4d35c466" "31e4a063dce5d68a906d0d27789955157fb44b07")
CROS_WORKON_TREE=("cc8ae75ea68e5c37c867b396c0540c8a109ed460" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb" "9d801dfece165c79072edb360bb407b4a44ddf11")
CROS_WORKON_PROJECT=("chromiumos/platform2" "chromiumos/platform/tast-tests")
CROS_WORKON_LOCALNAME=("platform2" "platform/tast-tests")
CROS_WORKON_DESTDIR=("${S}/platform2" "${S}/platform2/tast-tests")
CROS_WORKON_SUBTREE=("common-mk .gn" "helpers")

PLATFORM_SUBDIR="tast-tests/helpers/local"

inherit cros-workon platform

DESCRIPTION="Compiled executables used by local Tast tests in the cros bundle"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform/tast-tests/+/master/helpers"

LICENSE="BSD-Google GPL-3"
SLOT="0/0"
KEYWORDS="*"

COMMON_DEPEND="
	dev-cpp/gtest:=
	media-libs/minigbm:=
	x11-libs/libdrm:=
"
RDEPEND="
	${COMMON_DEPEND}
	chromeos-base/goldctl
"
DEPEND="${RDEPEND}"

src_install() {
	# Executable files' names take the form <category>.<TestName>.<bin_name>.
	exeinto /usr/libexec/tast/helpers/local/cros
	doexe "${OUT}"/*.[A-Z]*.*
	# Install symbol list file to the location required by minidump_stackwalk.
	# See https://www.chromium.org/developers/decoding-crash-dumps for details.
	local crasher_exec="${OUT}/platform.UserCrash.crasher"
	local id=$(head -n1 "${crasher_exec}.sym" | cut -d' ' -f 4)
	insinto "/usr/libexec/tast/helpers/local/cros/symbols/${crasher_exec##*/}/${id}"
	doins "${crasher_exec}.sym"
}
