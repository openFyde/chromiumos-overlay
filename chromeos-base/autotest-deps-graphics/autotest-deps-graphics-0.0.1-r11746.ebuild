# Copyright 2014 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=4
CROS_WORKON_COMMIT="5e46ba2ccecb0b7a1639e1c1e9300fd288a832d2"
CROS_WORKON_TREE="4f05ea61aed5a8252e9ea8092aeb16298af62d21"
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
