# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

# Python is required for tests and some build tasks.
CROS_WORKON_COMMIT="d92a270d2d9d6bb7ed3bf7dc3f698028550a65ef"
CROS_WORKON_TREE="6c580df11af0b8cc3ba4f77ba521a71517cfa4ed"
PYTHON_COMPAT=( python3_{6..9} )

CROS_WORKON_PROJECT="external/github.com/google/googletest"
CROS_WORKON_LOCALNAME="../third_party/googletest"

inherit cmake-multilib python-any-r1 cros-workon flag-o-matic

DESCRIPTION="Google C++ Testing Framework"
HOMEPAGE="https://github.com/google/googletest"

LICENSE="BSD"
KEYWORDS="*"
SLOT="0"
IUSE="doc examples test"

RDEPEND="!dev-cpp/gmock"
DEPEND="${RDEPEND}
	test? ( ${PYTHON_DEPS} )"

PATCHES=(
	# TODO(b/275542846): Remove these when build performance bug is fixed.
	"${FILESDIR}/0001-Revert-gmock-spec-builders-remove-the-name-for-an-un.patch"
	"${FILESDIR}/0002-Revert-gmock-spec-builders-add-support-for-non-movea.patch"
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
	# TODO(http://b/271867448): Remove once fixed.
	append-lfs-flags
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
