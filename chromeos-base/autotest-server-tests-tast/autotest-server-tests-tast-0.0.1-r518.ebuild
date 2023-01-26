# Copyright 2018 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
CROS_WORKON_COMMIT="f27b198f7b4870519524e4295d52b1c273ecc73b"
CROS_WORKON_TREE="3b77ff2653dfd9389955bd9d78b2a50d53e76280"
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
