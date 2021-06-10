# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CMAKE_ECLASS=cmake

inherit cmake-multilib

DESCRIPTION="Intel Graphics Memory Management Library"
HOMEPAGE="https://github.com/intel/gmmlib"
SRC_URI="https://github.com/intel/gmmlib/archive/refs/tags/intel-${P}.tar.gz"
S="${WORKDIR}/${PN}-intel-${P}"
KEYWORDS="*"
LICENSE="MIT"
SLOT="0"
IUSE="test"

RESTRICT="!test? ( test )"

RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-20.2.2_conditional_testing.patch
)

multilib_src_configure() {
	local mycmakeargs=(
		-DBUILD_TYPE=Release
		-DBUILD_TESTING=$(usex test)
	)
	cmake_src_configure
}
