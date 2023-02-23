# Copyright 2014 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
CROS_WORKON_COMMIT="14254eed651b39dd374d8190dbeee621d4dd4a7e"
CROS_WORKON_TREE="9135fe551ebd1bf94858d379a1705a976d14b24f"
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
