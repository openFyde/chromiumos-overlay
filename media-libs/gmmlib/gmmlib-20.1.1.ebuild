# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CMAKE_ECLASS=cmake

inherit cmake-multilib

DESCRIPTION="Intel Graphics Memory Management Library"
HOMEPAGE="https://github.com/intel/gmmlib"
SRC_URI="https://github.com/intel/gmmlib/archive/intel-${P}.tar.gz"
S="${WORKDIR}/${PN}-intel-${P}"
KEYWORDS="*"
LICENSE="MIT"
SLOT="0"

RDEPEND="${DEPEND}"
