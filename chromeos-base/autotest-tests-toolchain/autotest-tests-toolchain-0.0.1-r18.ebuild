# Copyright 2018 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
CROS_WORKON_COMMIT="8333412a9b5f88561f298edb61e586b2ea248ca6"
CROS_WORKON_TREE="3b6497abd42cffa9fb1fab2f76925fae42839b39"
CROS_WORKON_PROJECT="chromiumos/third_party/autotest"
CROS_WORKON_LOCALNAME="third_party/autotest/files"

PYTHON_COMPAT=( python3_{6..9} )

inherit cros-workon autotest python-any-r1

DESCRIPTION="Compilation and runtime tests for toolchain"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/third_party/autotest/"

LICENSE="GPL-2"
SLOT=0
KEYWORDS="*"
# Enable autotest by default.
IUSE="+autotest"

RDEPEND="
	!<chromeos-base/autotest-tests-0.0.3
	chromeos-base/toolchain-tests
"
DEPEND="${RDEPEND}"

IUSE_TESTS="
	+tests_platform_ToolchainTests
"

IUSE="${IUSE} ${IUSE_TESTS}"

AUTOTEST_FILE_MASK="*.a *.tar.bz2 *.tbz2 *.tgz *.tar.gz"
