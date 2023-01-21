# Copyright 2018 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="86f0c3affdb48553d8d937b32aacd49783e26a5f"
CROS_WORKON_TREE="72bc6e53df9b566b31aacc5d6407e003aaa318a4"
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
