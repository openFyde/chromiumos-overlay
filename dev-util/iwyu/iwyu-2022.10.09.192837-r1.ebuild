# Copyright 2022 The ChromiumOS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="6d416d5f90755dd76d55c0f33f9ac0de6dd27b5f"
CROS_WORKON_TREE="f842263b86e1d2c08d288b31b878752f0abd4ee9"
PYTHON_COMPAT=( python3_{6..9} )

CROS_WORKON_PROJECT="external/github.com/include-what-you-use/include-what-you-use"
CROS_WORKON_LOCALNAME="include-what-you-use"
CROS_WORKON_DESTDIR="${S}"

inherit cmake git-r3 cros-workon python-single-r1

DESCRIPTION="Include What You Use"
HOMEPAGE="https://include-what-you-use.org/"
SRC_URI=""

LICENSE="UoI-NCSA"
SLOT="0"
KEYWORDS="*"
IUSE=""

RDEPEND="${PYTHON_DEPS}"

DEPEND="
	sys-devel/llvm
	${RDEPEND}
"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

pkg_setup() {
	cros-workon_pkg_setup
	python-single-r1_pkg_setup
}

src_prepare() {
	cmake_src_prepare
	python_fix_shebang .
}
