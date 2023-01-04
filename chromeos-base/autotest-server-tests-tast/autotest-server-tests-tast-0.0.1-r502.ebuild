# Copyright 2018 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
CROS_WORKON_COMMIT="c97b8e81ad153d0ac4ce437fc3c6b7de68a201f6"
CROS_WORKON_TREE="49fad9fc899b809872802cd456c6f44e46d930f3"
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
