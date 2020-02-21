# Copyright 2014 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="5"
CROS_WORKON_COMMIT="8513c5c31bf62ffada516fe5e6cc50236856e02e"
CROS_WORKON_TREE="f7ca00eea7c7c3f9e1b02f9c07db05d66186212a"
CROS_WORKON_PROJECT="chromiumos/third_party/autotest"
CROS_WORKON_LOCALNAME="third_party/autotest/files"

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
