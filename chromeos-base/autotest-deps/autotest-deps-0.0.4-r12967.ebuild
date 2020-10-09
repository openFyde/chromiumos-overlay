# Copyright (c) 2010 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="5"
CROS_WORKON_COMMIT="420a96892b4762fb1515d0b1a62084895cdddd59"
CROS_WORKON_TREE="27309a31ef8b4a30f01f77f0d371325de1a206bb"
CROS_WORKON_PROJECT="chromiumos/third_party/autotest"
CROS_WORKON_LOCALNAME="third_party/autotest/files"

inherit cros-workon autotest-deponly

DESCRIPTION="Autotest common deps"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/third_party/autotest/"
SRC_URI=""
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="*"

# Autotest enabled by default.
IUSE="+autotest"

# following deps don't compile: boottool, mysql, pgpool, pgsql, systemtap, # dejagnu, libcap, libnet
# following deps are not deps: factory
# following tests are going to be moved: chrome_test
AUTOTEST_DEPS_LIST="gtest iwcap"
AUTOTEST_CONFIG_LIST=*
AUTOTEST_PROFILERS_LIST=*

# NOTE: For deps, we need to keep *.a
AUTOTEST_FILE_MASK="*.tar.bz2 *.tbz2 *.tgz *.tar.gz"

# deps/gtest
RDEPEND="
	dev-cpp/gtest:=
"

# deps/iwcap
RDEPEND="${RDEPEND}
	dev-libs/libnl:0
"

# deps/grpcio
RDEPEND="${RDEPEND}
	>=dev-python/grpcio-1.19
"

# deps/psutil
RDEPEND="${RDEPEND}
	>=dev-python/psutil-5.5.0
"

RDEPEND="${RDEPEND}
	sys-devel/binutils
"
DEPEND="${RDEPEND}"

src_prepare() {
	autotest-deponly_src_prepare

	# To avoid a file collision with autotest.ebuild, remove
	# one particular __init__.py file from working directory.
	# See crbug.com/324963 for context.
	rm "${AUTOTEST_WORKDIR}/client/profilers/__init__.py"
}
