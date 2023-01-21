# Copyright 2014 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
CROS_WORKON_COMMIT="86f0c3affdb48553d8d937b32aacd49783e26a5f"
CROS_WORKON_TREE="72bc6e53df9b566b31aacc5d6407e003aaa318a4"
CROS_WORKON_PROJECT="chromiumos/third_party/autotest"
CROS_WORKON_LOCALNAME="third_party/autotest/files"

inherit cros-workon autotest

DESCRIPTION="debugd autotests"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/third_party/autotest/"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="*"
# Enable autotest by default.
IUSE="+autotest"

RDEPEND="
	!<chromeos-base/autotest-tests-0.0.3
"

IUSE_TESTS="
"

IUSE="${IUSE} ${IUSE_TESTS}"

AUTOTEST_FILE_MASK="*.a *.tar.bz2 *.tbz2 *.tgz *.tar.gz"
