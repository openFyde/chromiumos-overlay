# Copyright 2014 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=4
CROS_WORKON_COMMIT="d387bcc97776b7b64b706a639123335e13ab9720"
CROS_WORKON_TREE="c6f03621b8cf44d23fdf2c59f846f48335d81d6f"
CROS_WORKON_PROJECT="chromiumos/third_party/autotest"
CROS_WORKON_LOCALNAME=../third_party/autotest/files

inherit cros-workon autotest-deponly

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
