# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

: "${CMAKE_MAKEFILE_GENERATOR=ninja}"
PYTHON_COMPAT=( python3_{6..9} )

inherit cmake python-single-r1

DESCRIPTION="Super-parallel Python port of the C-Reduce"
HOMEPAGE="https://github.com/marxin/cvise/"
SRC_URI="
	https://github.com/marxin/cvise/archive/v${PV}.tar.gz -> ${P}.tar.gz
"

LICENSE="UoI-NCSA"
SLOT="0"
KEYWORDS="*"
IUSE="test"
RESTRICT="!test? ( test )"
REQUIRED_USE=${PYTHON_REQUIRED_USE}

DEPEND="sys-devel/llvm"
RDEPEND="${DEPEND}
	${PYTHON_DEPS}
	$(python_gen_cond_dep '
		dev-python/chardet[${PYTHON_USEDEP}]
		dev-python/pebble[${PYTHON_USEDEP}]
		dev-python/psutil[${PYTHON_USEDEP}]
	')
	dev-util/unifdef
	sys-devel/flex"
BDEPEND="
	${PYTHON_DEPS}
	sys-devel/flex
	test? (
		$(python_gen_cond_dep '
			dev-python/pebble[${PYTHON_USEDEP}]
			dev-python/pytest[${PYTHON_USEDEP}]
		')
	)"

pkg_setup() {
	python-single-r1_pkg_setup
}

PATCHES=( "${FILESDIR}"/cvise-2.4-build-cxx17.patch )

src_prepare() {
	if has_version "sys-devel/llvm[llvm-next]" || has_version ">sys-devel/llvm-15.0_pre458507_p20220602-r1000"; then
		eapply "${FILESDIR}/0001-refactors-so-that-the-project-is-LLVM-15-compatible.patch"
		eapply_user
	fi
	sed -i -e 's:-n auto::' -e 's:--flake8::' setup.cfg || die
	cmake_src_prepare
}

src_test() {
	cd "${BUILD_DIR}" || die
	epytest
}

src_install() {
	cmake_src_install

	python_fix_shebang "${ED}"/usr/bin/cvise
}
