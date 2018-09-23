# Copyright (c) 2012 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5
CROS_WORKON_COMMIT="d5c4d93954e42ab1d5495ebb4116827ac39b3b4b"
CROS_WORKON_TREE="6003c34f57aeddee0e2c3b29358bd57cf4d1b66e"
CROS_WORKON_PROJECT="chromiumos/third_party/autotest"
CROS_WORKON_LOCALNAME=../third_party/autotest/files

inherit cros-workon autotest-deponly cros-debug libchrome

DESCRIPTION="Autotest glbench dep"
HOMEPAGE="http://www.chromium.org/"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="*"

# Autotest enabled by default.
IUSE="+autotest X"

RDEPEND="${RDEPEND}
	>=dev-cpp/gflags-2.0
	media-libs/libpng
	!opengles? ( virtual/opengl )
	opengles? ( virtual/opengles )
	media-libs/waffle
"

DEPEND="${RDEPEND}
	x11-drivers/opengles-headers"

AUTOTEST_DEPS_LIST="glbench"

# NOTE: For deps, we need to keep *.a
AUTOTEST_FILE_MASK="*.tar.bz2 *.tbz2 *.tgz *.tar.gz"

src_prepare() {
	autotest-deponly_src_prepare
	cros-debug-add-NDEBUG
}

src_configure() {
	cros-workon_src_configure
}
