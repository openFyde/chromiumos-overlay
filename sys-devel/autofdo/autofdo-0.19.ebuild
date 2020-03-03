# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit autotools flag-o-matic

DESCRIPTION="Utilies for generating, examining AFDO profiles"
HOMEPAGE="http://gcc.gnu.org/wiki/AutoFDO"
SRC_URI="https://github.com/google/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="*"
IUSE=""

DEPEND="dev-libs/openssl:0=
	dev-libs/protobuf:=
	dev-libs/libffi
	sys-devel/llvm
	sys-libs/zlib"
RDEPEND="${DEPEND}"

src_prepare() {
	# Link with libLLVM, since we are building LLVM dynamically and linking
	# it statically, see http://crbug.com/936051.
	epatch "${FILESDIR}/autofdo-0.19-link-with-libllvm.patch"

	# Upstream AutoFDO needs to build protobuf with source, but the build
	# script doesn't work on Chrome OS. Since Chrome OS has protobuf library,
	# we can use the system library instead of building a new one.
	epatch "${FILESDIR}/autofdo-0.19-use-system-protobuf.patch"

	# Fix clang error reported in https://crbug.com/1057903
	epatch "${FILESDIR}/autofdo-0.19-llvm-stringref-error.patch"

	# The upstream tarball does not have aclocal.m4, and the upstream
	# Makefile.in is generated from automake 1.15. We are still using
	# automake 1.14. This mismatch makes the build fail.
	# https://github.com/google/autofdo/issues/60
	# We need to regenerate the Makefile.
	eautoreconf
}

src_configure() {
	append-ldflags $(no-as-needed)
	econf
}

src_compile() {
	MAKEOPTS="-j1" emake
}

src_install() {
	dobin create_gcov create_llvm_prof dump_gcov profile_diff \
		profile_merger profile_update sample_merger
}
