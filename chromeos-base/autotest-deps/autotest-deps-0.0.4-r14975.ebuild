# Copyright (c) 2010 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="5"
CROS_WORKON_COMMIT="15edb588ef2ed50bee08c798cd114fdf0b5aab98"
CROS_WORKON_TREE="6fa2f1fc26bc0029a232e502ad9cb0a7e9ac075c"
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
	dev-libs/libnl:0
	>=dev-python/grpcio-1.19
	>=dev-python/psutil-5.5.0
	sys-devel/binutils
"

DEPEND="${RDEPEND}
	chromeos-base/cros-config-api
"

src_prepare() {
	autotest-deponly_src_prepare

	# To avoid a file collision with autotest.ebuild, remove
	# one particular __init__.py file from working directory.
	# See crbug.com/324963 for context.
	rm "${AUTOTEST_WORKDIR}/client/profilers/__init__.py"
}
