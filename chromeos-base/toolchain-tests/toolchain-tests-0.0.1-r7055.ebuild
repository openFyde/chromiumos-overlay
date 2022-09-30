# Copyright 2018 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="063aa30b94d34ad275cac62c2dfcaba03f46bb22"
CROS_WORKON_TREE="cc9d42c334f6ea5b7cdabcfbb66290a769e6f6c2"
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
