# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

# Python is required for tests and some build tasks.
CROS_WORKON_COMMIT="703bd9caab50b139428cea1aaff9974ebee5742e"
CROS_WORKON_TREE="1d4733d71941ad40050897c3a30919a488700f06"
PYTHON_COMPAT=( python3_{6..9} pypy )

CROS_WORKON_PROJECT="external/github.com/google/googletest"
CROS_WORKON_LOCALNAME="../third_party/googletest"

inherit cmake-multilib python-any-r1 cros-workon

DESCRIPTION="Google C++ Testing Framework"
HOMEPAGE="https://github.com/google/googletest"

LICENSE="BSD"
KEYWORDS="*"
SLOT="0"
IUSE="doc examples test"

RDEPEND="!dev-cpp/gmock"
DEPEND="${RDEPEND}
	test? ( ${PYTHON_DEPS} )"

pkg_setup() {
	use test && python-any-r1_pkg_setup
}

src_prepare() {
	cmake-utils_src_prepare

	sed -i -e '/set(cxx_base_flags /s:-Werror::' \
		googletest/cmake/internal_utils.cmake || die "sed failed!"
}

multilib_src_configure() {
	# Building gtest with "-Os" breaks unit tests in asan builds,
	# https://crbug.com/1069493
	cros_optimize_package_for_speed
	local mycmakeargs=(
		-DBUILD_GMOCK=ON
		-DINSTALL_GTEST=ON
		-DBUILD_SHARED_LIBS=ON

		# tests
		-Dgmock_build_tests=$(usex test)
		-Dgtest_build_tests=$(usex test)
		-DPYTHON_EXECUTABLE="${PYTHON}"
	)
	cmake-utils_src_configure
}

multilib_src_install_all() {
	einstalldocs

	if use doc; then
		docinto googletest
		dodoc -r googletest/docs/.
		docinto googlemock
		dodoc -r googlemock/docs/.
	fi

	if use examples; then
		docinto examples
		dodoc googletest/samples/*.{cc,h}
	fi
}
