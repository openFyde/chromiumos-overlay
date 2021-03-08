# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="41959d2566d1a66879a0b65e1d1faf8d7cfa0723"
CROS_WORKON_TREE="eaed4f3b0a8201ef3951bf1960728885ff99e772"
inherit cros-constants

CROS_WORKON_PROJECT=("chromiumos/platform2")
CROS_WORKON_LOCALNAME=("platform2")
CROS_WORKON_DESTDIR=("${S}/platform2")
CROS_WORKON_SUBTREE=("common-mk")

inherit base cmake-utils cros-workon flag-o-matic platform git-r3

DESCRIPTION="Intel GNA library for Gemini Lake and Tiger Lake"
HOMEPAGE="https://github.com/intel/gna"

LICENSE="LGPL-2.1"
KEYWORDS="*"
IUSE="+clang"
SLOT="0"

RDEPEND="${DEPEND}"

src_unpack() {
	platform_src_unpack

	EGIT_REPO_URI="https://github.com/intel/gna.git" \
	EGIT_CHECKOUT_DIR="${S}" \
	EGIT_COMMIT="691b58abb87ddfdef9101459e311bdb82620bfa6" \
	EGIT_BRANCH="main" \
	git-r3_src_unpack
}

src_prepare() {
	eapply "${FILESDIR}/0001-Enable-changes-needed-for-ChromeOS-build.patch"
	eapply_user
	cmake-utils_src_prepare
}

src_configure() {
	cros_enable_cxx_exceptions
	append-flags "-fvisibility=default"
	local mycmakeargs=(
		-DCMAKE_BUILD_TYPE=Release
		-DTARGET_OS="ChromeOS"
	)

	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile

	cp -fpru "${CMAKE_USE_DIR}"/bin/gna-lib/LNX-RELEASE/x64/libgna.so.2.0.0.0 "${WORKDIR}"
	cp -fpru "${CMAKE_USE_DIR}"/bin/gna-lib/LNX-RELEASE/x64/libgna.so.2 "${WORKDIR}"
	cp -fpru "${CMAKE_USE_DIR}"/bin/gna-lib/LNX-RELEASE/x64/libgna.so "${WORKDIR}"
	cp -fpru "${S}"/bin/gna-lib/include "${WORKDIR}"
	cp -fpru "${S}"/src/common/gna*.h "${WORKDIR}"/include
}
src_install() {
	dolib.so "${WORKDIR}"/libgna.so.2.0.0.0
	dolib.so "${WORKDIR}"/libgna.so.2
	dolib.so "${WORKDIR}"/libgna.so
	insinto "/usr/include"
	doins "${WORKDIR}"/include/*
}
