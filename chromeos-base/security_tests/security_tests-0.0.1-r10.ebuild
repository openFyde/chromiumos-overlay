# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI="6"

CROS_WORKON_COMMIT="b548b650267258f203514ed37b9d02dc85cd5dc7"
CROS_WORKON_TREE=("685ac64e26e21b14bc11ff4e62d61a23f47cbdf2" "c4583c01a6958e6255d1c052237ac91003afe0f3" "dc1506ef7c8cfd2c5ffd1809dac05596ec18773c")
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk security_tests .gn"

PLATFORM_SUBDIR="security_tests"

inherit cros-workon platform

DESCRIPTION="Compiled executables used by Tast security tests"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/security_tests"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"

src_install() {
	# Executable files' names take the form security.<TestName>.<bin_name>.
	exeinto /usr/libexec/security_tests
	doexe "${OUT}"/security.*.*
}
