# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/nss/nss-3.12.3-r1.ebuild,v 1.8 2009/09/05 20:39:37 keytoaster Exp $

inherit eutils flag-o-matic multilib toolchain-funcs

NSPR_VER="4.7.4"
RTM_NAME="NSS_${PV//./_}_RTM"
DESCRIPTION="Mozilla's Network Security Services library that implements PKI support"
HOMEPAGE="http://www.mozilla.org/projects/security/pki/nss/"
SRC_URI="ftp://ftp.mozilla.org/pub/mozilla.org/security/nss/releases/${RTM_NAME}/src/${P}.tar.bz2"
#SRC_URI="http://dev.gentoo.org/~armin76/dist/${P}.tar.bz2
#	mirror://gentoo/${P}.tar.bz2"

LICENSE="|| ( MPL-1.1 GPL-2 LGPL-2.1 )"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 sparc x86 ~x86-fbsd"

DEPEND=">=dev-libs/nspr-${NSPR_VER}
	>=dev-libs/nss-3.12.3-r1
	>=dev-db/sqlite-3.5
	sys-libs/zlib"
RDEPEND="${DEPEND}"

src_unpack() {
	unpack ${A}

	cd "${S}"/mozilla/security/coreconf
	# hack nspr paths
	echo 'INCLUDES += -I/usr/include/nspr -I$(DIST)/include/dbm' \
		>> headers.mk || die "failed to append include"

	# cope with nspr being in /usr/$(get_libdir)/nspr
	sed -e 's:$(DIST)/lib:/usr/'"$(get_libdir)"/nspr':' \
		-i location.mk

	# modify install path
	sed -e 's:SOURCE_PREFIX = $(CORE_DEPTH)/\.\./dist:SOURCE_PREFIX = $(CORE_DEPTH)/dist:' \
		-i source.mk

	# Respect LDFLAGS
	sed -i -e 's/\$(MKSHLIB) -o/\$(MKSHLIB) \$(LDFLAGS) -o/g' rules.mk

	cd "${S}"
	epatch "${FILESDIR}"/${PN}-3.12-config.patch
	epatch "${FILESDIR}"/${PN}-3.12-config-1.patch
	epatch "${FILESDIR}"/${PN}-mips64-2.patch
	epatch "${FILESDIR}"/${P}-executable-stacks.patch
	epatch "${FILESDIR}"/${P}-shlibsign.patch
}

src_compile() {
	strip-flags

	echo > "${T}"/test.c
	$(tc-getCC) -c "${T}"/test.c -o "${T}"/test.o
	case $(file "${T}"/test.o) in
	*64-bit*) export USE_64=1;;
	*32-bit*) ;;
	*) die "Failed to detect whether your arch is 64bits or 32bits, disable distcc if you're using it, please";;
	esac

	export NSDISTMODE=copy
	export NSS_USE_SYSTEM_SQLITE=1
	export NSS_ENABLE_ECC=1
	export NSPR_LIB_DIR="/usr/$(get_libdir)/nspr"

	# Cross-compile Love
	( filter-flags -m* ;
	  cd "${S}"/mozilla/security/coreconf &&
	  emake -j1 BUILD_OPT=1 XCFLAGS="${CFLAGS}" LDFLAGS= CC="$(tc-getBUILD_CC)" || die "coreconf make failed" )
	cd "${S}"/mozilla/security/dbm
	NSINSTALL=$(readlink -f $(find "${S}"/mozilla/security/coreconf -type f -name nsinstall))
	emake -j1 BUILD_OPT=1 XCFLAGS="${CFLAGS}" CC="$(tc-getCC)" NSINSTALL="${NSINSTALL}" NSPR_INCLUDE_DIR="${ROOT}"/usr/include/nspr OS_TEST=${ARCH} || die "dbm make failed"
	cd "${S}"/mozilla/security/nss
	if tc-is-cross-compiler; then
	   SHLIBSIGN_ARG="SHLIBSIGN=/usr/bin/nssshlibsign"
	fi
	emake -j1 BUILD_OPT=1 XCFLAGS="${CFLAGS}" CC="$(tc-getCC)" NSINSTALL="${NSINSTALL}" NSPR_INCLUDE_DIR="${ROOT}"/usr/include/nspr NSPR_LIB_DIR="${ROOT}"/usr/lib/nspr OS_TEST=${ARCH} ${SHLIBSIGN_ARG} || die "nss make failed"
}

src_install () {
	cd "${S}"/mozilla/security/dist/*/bin/
	for f in *; do
		newbin ${f} nss${f}
	done
}
