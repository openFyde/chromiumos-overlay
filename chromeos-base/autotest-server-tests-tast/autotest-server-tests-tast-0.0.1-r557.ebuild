# Copyright 2018 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="ad17d646b7576b5850c9356f15c562b76f7f8cf1"
CROS_WORKON_TREE="e0c014d09495d51cfadb4245acd144ef3582747c"
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
