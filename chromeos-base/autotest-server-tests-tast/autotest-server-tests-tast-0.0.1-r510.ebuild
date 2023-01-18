# Copyright 2018 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
CROS_WORKON_COMMIT="3f3a686df5497a9296ff0fdf3d2ec0bbda508d4b"
CROS_WORKON_TREE="3c72243b9a0ce7cfbc23cd2337368fcb668bd95d"
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
