# Copyright 2018 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="6f9dfd1c2bbf49d32dc237574d82be1635a7a6b5"
CROS_WORKON_TREE="1c0498e1be6b2c240d2d250ca46262a135fcbb11"
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
