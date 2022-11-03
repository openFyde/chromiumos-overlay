# Copyright 2018 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="5529bc1c9234aab58eb926fb22403e3ba65f4f4c"
CROS_WORKON_TREE="e3fbf36efc149c876210ef2d6335ddbca399c2aa"
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
