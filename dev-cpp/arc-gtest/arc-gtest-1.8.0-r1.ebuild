# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

AUTOTOOLS_AUTORECONF=1
AUTOTOOLS_IN_SOURCE_BUILD=1
# Python is required for tests and some build tasks.
PYTHON_COMPAT=( python2_7 )

inherit eutils python-any-r1 autotools-multilib arc-build

DESCRIPTION="Google C++ Testing Framework"
HOMEPAGE="http://github.com/google/googletest/"
SRC_URI="https://github.com/google/googletest/archive/release-${PV}.tar.gz -> googletest-release-${PV}.tar.gz"
SRC_URI="https://commondatastorage.googleapis.com/chromeos-localmirror/distfiles/googletest-release-${PV}.tar.gz"
S="${WORKDIR}/googletest-release-${PV}/googletest"

LICENSE="BSD"
SLOT="0"
KEYWORDS="*"
IUSE=""

DEPEND="${PYTHON_DEPS}"
RDEPEND=""

PATCHES=(
	"${FILESDIR}/configure-fix-pthread-linking.patch" #371647
	"${FILESDIR}/${P}-makefile-am.patch"
	"${FILESDIR}/${P}-threadlocal-api.patch"
	"${FILESDIR}/${P}-GTEST_HAS_CXXABI_H_.patch"
)

src_prepare() {
	autotools-multilib_src_prepare
}

src_configure() {
	arc-build-select-clang
	multilib-minimal_src_configure
}

multilib_src_configure() {
	ECONF_SOURCE="${S}" econf \
		--prefix="${ARC_PREFIX}/vendor" \
		--datadir="${ARC_PREFIX}/vendor/share"
}

multilib_src_install() {
	default
	exeinto "${ARC_PREFIX}/vendor/bin"
	newexe scripts/gtest-config "gtest-config-${ABI}"
}

multilib_src_install_all() {
	prune_libtool_files --all
}
