# Copyright 2014 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="5"
CROS_WORKON_COMMIT="7afb54fd58ca7aaf18770786f1be6f765c382d56"
CROS_WORKON_TREE="b6c72b872f4064a216b56d46a79866b8014ff7aa"
CROS_WORKON_PROJECT="chromiumos/third_party/autotest"
CROS_WORKON_LOCALNAME=../third_party/autotest/files

PYTHON_COMPAT=( python2_7 )
inherit cros-workon autotest-deponly python-any-r1

DESCRIPTION="Autotest p2p deps"
HOMEPAGE="http://www.chromium.org/"
SRC_URI=""
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="*"

# Autotest enabled by default.
IUSE="+autotest"

AUTOTEST_DEPS_LIST="lansim"

# NOTE: For deps, we need to keep *.a
AUTOTEST_FILE_MASK="*.tar.bz2 *.tbz2 *.tgz *.tar.gz"

RDEPEND="!<chromeos-base/autotest-deps-0.0.4"

# deps/lansim
RDEPEND="${RDEPEND}
	dev-python/dpkt
"
DEPEND="${RDEPEND}"
