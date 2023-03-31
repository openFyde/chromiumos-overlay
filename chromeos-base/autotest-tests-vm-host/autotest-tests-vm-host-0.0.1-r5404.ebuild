# Copyright 2018 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="75bc005dd26f3c08987aea95f918530c7e51935c"
CROS_WORKON_TREE="df02abdc4c7b3e6848f5f8d0f3d8cf46000d1907"
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
