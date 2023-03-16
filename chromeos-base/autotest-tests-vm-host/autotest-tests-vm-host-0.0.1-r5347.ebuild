# Copyright 2018 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="33087bfd66d7d622ecd1d66314fd539a25f03c9a"
CROS_WORKON_TREE="43bfb4263a89dda5e4bde8bfaf43b8d266b53f4c"
PYTHON_COMPAT=( python3_{6..9} )

CROS_WORKON_PROJECT="chromiumos/third_party/autotest"
CROS_WORKON_LOCALNAME="third_party/autotest/files"

inherit cros-workon autotest python-any-r1

DESCRIPTION="kvm host autotests"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/third_party/autotest/"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="*"
IUSE="+autotest"

RDEPEND=""
DEPEND="${RDEPEND}"

IUSE_TESTS="
	+tests_vm_CrosVmStart
"

IUSE="${IUSE} ${IUSE_TESTS}"

AUTOTEST_FILE_MASK="*.a *.tar.bz2 *.tbz2 *.tgz *.tar.gz"
