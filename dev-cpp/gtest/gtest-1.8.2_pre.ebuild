# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

# Python is required for tests and some build tasks.
PYTHON_COMPAT=( python3_{6..9} pypy )

inherit cmake-multilib python-any-r1

if [[ ${PV} == "9999" ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/google/googletest"
else
	# Chromium & breakpad use a newer version than the latest upstream release.
	GIT_COMMIT="5ec7f0c4a113e2f18ac2c6cc7df51ad6afc24081"
	SRC_URI="https://github.com/google/googletest/archive/${GIT_COMMIT}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="*"
	S="${WORKDIR}"/googletest-${GIT_COMMIT}
fi

DESCRIPTION="Google C++ Testing Framework"
HOMEPAGE="https://github.com/google/googletest"

LICENSE="BSD"
SLOT="0"
IUSE="doc examples test"

RDEPEND="!dev-cpp/gmock"
DEPEND="${RDEPEND}
	test? ( ${PYTHON_DEPS} )"

PATCHES=(
	"${FILESDIR}"/${PN}-9999-fix-gcc6-undefined-behavior.patch
	"${FILESDIR}"/${PN}-1.8.0-increase-clone-stack-size.patch
)

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
