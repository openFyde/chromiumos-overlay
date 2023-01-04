# Copyright 2018 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="f4b225485d7d05a9d409e99958eb82fbd906cd18"
CROS_WORKON_TREE="e81d98296c954229f8a23eb55bc4fdb1974ab026"
PYTHON_COMPAT=( python3_{6..9} )

CROS_WORKON_PROJECT="chromiumos/third_party/autotest"
CROS_WORKON_LOCALNAME="third_party/autotest/files"

inherit cros-workon python-any-r1

DESCRIPTION="Compilation and runtime tests for toolchain"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/third_party/autotest/"

LICENSE="BSD-Google"
KEYWORDS="*"

src_unpack() {
	cros-workon_src_unpack
	S+="/client/site_tests/platform_ToolchainTests/src"
}

src_test() {
	einfo "Testing llvm-profdata..."
	"${FILESDIR}/llvm-profdata-test.py" || die
	default
}
