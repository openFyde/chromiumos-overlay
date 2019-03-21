# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI="6"

CROS_WORKON_COMMIT="16e8902570a5509cdcce356f625402e80253528f"
CROS_WORKON_TREE=("13228e56ac75327ed92fe81d6a0ed4f5c11c2a6a" "ba5b1f1a14eeefe3a5f40bc6f42c66f3f906635e" "dc1506ef7c8cfd2c5ffd1809dac05596ec18773c")
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
