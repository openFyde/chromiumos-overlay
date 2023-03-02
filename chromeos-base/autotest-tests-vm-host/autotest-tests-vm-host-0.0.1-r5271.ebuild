# Copyright 2018 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="ad17d646b7576b5850c9356f15c562b76f7f8cf1"
CROS_WORKON_TREE="e0c014d09495d51cfadb4245acd144ef3582747c"
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
