# Copyright 2018 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
CROS_WORKON_COMMIT="b032fe1fc10b37bf42c6593251d8e32a4d3ee747"
CROS_WORKON_TREE="7e4a702cf0cc7966f15bac1dc0ddbb63b0cff173"
CROS_WORKON_PROJECT="chromiumos/third_party/autotest"
CROS_WORKON_LOCALNAME="third_party/autotest/files"

inherit cros-workon autotest

DESCRIPTION="Autotest server tests for running Tast-based tests"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform/tast/"
SRC_URI=""
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="*"

IUSE="+autotest"

RDEPEND=""
DEPEND=""

IUSE_TESTS="
	+tests_tast
"

IUSE="${IUSE} ${IUSE_TESTS}"

AUTOTEST_FILE_MASK="*.a *.tar.bz2 *.tbz2 *.tgz *.tar.gz"
