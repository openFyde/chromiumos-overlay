# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

inherit eutils

DESCRIPTION="Transitional Package - Google C++ Mocking Framework"
HOMEPAGE="http://github.com/google/googletest/"

LICENSE="BSD"
SLOT="0"
KEYWORDS="*"
IUSE="test"

RDEPEND="!<dev-cpp/gtest-1.8.0"
DEPEND="${RDEPEND}"
