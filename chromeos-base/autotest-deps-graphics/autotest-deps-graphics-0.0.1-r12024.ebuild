# Copyright 2014 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=4
CROS_WORKON_COMMIT="14254eed651b39dd374d8190dbeee621d4dd4a7e"
CROS_WORKON_TREE="9135fe551ebd1bf94858d379a1705a976d14b24f"
CROS_WORKON_PROJECT="chromiumos/third_party/autotest"
CROS_WORKON_LOCALNAME="third_party/autotest/files"

inherit cros-workon autotest-deponly

DESCRIPTION="Dependencies for graphics autotests"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/third_party/autotest/"
SRC_URI=""
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="*"

# Autotest enabled by default.
IUSE="+autotest"

AUTOTEST_DEPS_LIST="graphics"

# NOTE: For deps, we need to keep *.a
AUTOTEST_FILE_MASK="*.tar.bz2 *.tbz2 *.tgz *.tar.gz"

RDEPEND="!<chromeos-base/autotest-deps-0.0.4"
DEPEND="${RDEPEND}"
