# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/openssl/openssl-0.9.8o.ebuild,v 1.6 2010/06/21 20:43:49 maekke Exp $

EAPI="2"

inherit eutils flag-o-matic toolchain-funcs cros-workon

DESCRIPTION="Toolkit for SSL v2/v3 and TLS v1"
HOMEPAGE="http://www.openssl.org/"
LICENSE="openssl"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="bindist gmp kerberos pkcs11 sse2 test zlib"
CROS_WORKON_PROJECT="chromiumos/third_party/openssl"

RDEPEND="gmp? ( dev-libs/gmp )
	zlib? ( sys-libs/zlib )
	kerberos? ( app-crypt/mit-krb5 )"
DEPEND="${RDEPEND}
	sys-apps/diffutils
	>=dev-lang/perl-5
	test? ( sys-devel/bc )"
PDEPEND="app-misc/ca-certificates
	 pkcs11? ( chromeos-base/chaps )"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-0.9.8h-ldflags.patch #181438
	if use pkcs11; then
		sed \
			-e "s:@GENTOO_LIBDIR@:/usr/$(get_libdir):" \
			"${FILESDIR}"/${PN}-pkcs11-engine-r1.patch \
			> "${T}"/pkcs11.patch
		epatch "${T}"/pkcs11.patch
	fi
	epatch "${FILESDIR}"/${PN}-0.9.8r-verify-retcode.patch

	# disable fips in the build
	# make sure the man pages are suffixed #302165
	# don't bother building man pages if they're disabled
	sed -i \
		-e '/DIRS/s: fips : :g' \
		-e '/^MANSUFFIX/s:=.*:=ssl:' \
		-e '/^MAKEDEPPROG/s:=.*:=$(CC):' \
		-e $(has noman FEATURES \
			&& echo '/^install:/s:install_docs::' \
			|| echo '/^MANDIR=/s:=.*:=/usr/share/man:') \
		Makefile{,.org} \
		|| die
	# show the actual commands in the log
	sed -i '/^SET_X/s:=.*:=set -x:' Makefile.shared
	# update the enginedir path
	sed -i \
		-e "/foo.*engines/s|/lib/engines|/$(get_libdir)/engines|" \
		Configure || die

	# allow openssl to be cross-compiled
	cp "${FILESDIR}"/gentoo.config-0.9.8 gentoo.config || die "cp cross-compile failed"
	chmod a+rx gentoo.config

	append-flags -fno-strict-aliasing
	append-flags -Wa,--noexecstack

	sed -i '1s,^:$,#!/usr/bin/perl,' Configure #141906
	sed -i '/^"debug-steve/d' Configure # 0.9.8k shipped broken
	./config --test-sanity || die "I AM NOT SANE"
}

src_configure() {
	unset APPS #197996
	unset SCRIPTS #312551

	tc-export CC AR RANLIB

	# Clean out patent-or-otherwise-encumbered code
	# Camellia: Royalty Free            http://en.wikipedia.org/wiki/Camellia_(cipher)
	# IDEA:     5,214,703 25/05/2010    http://en.wikipedia.org/wiki/International_Data_Encryption_Algorithm
	# EC:       ????????? ??/??/2015    http://en.wikipedia.org/wiki/Elliptic_Curve_Cryptography
	# MDC2:     Expired                 http://en.wikipedia.org/wiki/MDC-2
	# RC5:      5,724,428 03/03/2015    http://en.wikipedia.org/wiki/RC5

	use_ssl() { use $1 && echo "enable-${2:-$1} ${*:3}" || echo "no-${2:-$1}" ; }
	echoit() { echo "$@" ; "$@" ; }

	local krb5=$(has_version app-crypt/mit-krb5 && echo "MIT" || echo "Heimdal")

	local sslout=$(./gentoo.config)
	einfo "Use configuration ${sslout:-(openssl knows best)}"
	local config="Configure"
	[[ -z ${sslout} ]] && config="config"
	echoit \
	./${config} \
		${sslout} \
		$(use sse2 || echo "no-sse2") \
		enable-camellia \
		$(use_ssl !bindist ec) \
		$(use_ssl !bindist idea) \
		enable-mdc2 \
		$(use_ssl !bindist rc5) \
		enable-tlsext \
		$(use_ssl gmp gmp -lgmp) \
		$(use_ssl kerberos krb5 --with-krb5-flavor=${krb5}) \
		$(use_ssl zlib) \
		--prefix=/usr \
		--openssldir=/etc/ssl \
		shared threads \
		|| die "Configure failed"

	# Clean out hardcoded flags that openssl uses
	local CFLAG=$(grep ^CFLAG= Makefile | LC_ALL=C sed \
		-e 's:^CFLAG=::' \
		-e 's:-fomit-frame-pointer ::g' \
		-e 's:-O[0-9] ::g' \
		-e 's:-march=[-a-z0-9]* ::g' \
		-e 's:-mcpu=[-a-z0-9]* ::g' \
		-e 's:-m[a-z0-9]* ::g' \
	)
	sed -i \
		-e "/^LIBDIR=/s|=.*|=$(get_libdir)|" \
		-e "/^CFLAG/s|=.*|=${CFLAG} ${CFLAGS}|" \
		-e "/^SHARED_LDFLAGS=/s|$| ${LDFLAGS}|" \
		Makefile || die
}

src_compile() {
	# depend is needed to use $confopts
	# rehash is needed to prep the certs/ dir
	emake -j1 depend || die "depend failed"
	emake -j1 all rehash || die "make all failed"
}

# Tests disabled: `openssl req` tests fail.
# TODO(ellyjones): fix me :)
# src_test() {
# 	emake -j1 test || die "make test failed"
# }

src_install() {
	emake -j1 INSTALL_PREFIX="${D}" install || die
	dodoc CHANGES* FAQ NEWS README doc/*.txt doc/c-indentation.el
	dohtml -r doc/*

	# create the certs directory
	dodir /etc/ssl/certs
	cp -RP certs/* "${D}"/etc/ssl/certs/ || die "failed to install certs"
	rm -r "${D}"/etc/ssl/certs/{demo,expired}

	# Namespace openssl programs to prevent conflicts with other man pages
	cd "${D}"/usr/share/man
	local m d s
	for m in $(find . -type f | xargs grep -L '#include') ; do
		d=${m%/*} ; d=${d#./} ; m=${m##*/}
		[[ ${m} == openssl.1* ]] && continue
		[[ -n $(find -L ${d} -type l) ]] && die "erp, broken links already!"
		mv ${d}/{,ssl-}${m}
		# fix up references to renamed man pages
		sed -i '/^[.]SH "SEE ALSO"/,/^[.]/s:\([^(, ]*(1)\):ssl-\1:g' ${d}/ssl-${m}
		ln -s ssl-${m} ${d}/openssl-${m}
		# locate any symlinks that point to this man page ... we assume
		# that any broken links are due to the above renaming
		for s in $(find -L ${d} -type l) ; do
			s=${s##*/}
			rm -f ${d}/${s}
			ln -s ssl-${m} ${d}/ssl-${s}
			ln -s ssl-${s} ${d}/openssl-${s}
		done
	done
	[[ -n $(find -L ${d} -type l) ]] && die "broken manpage links found :("

	dodir /etc/sandbox.d #254521
	echo 'SANDBOX_PREDICT="/dev/crypto"' > "${D}"/etc/sandbox.d/10openssl

	diropts -m0700
	keepdir /etc/ssl/private
}

pkg_preinst() {
	preserve_old_lib /usr/$(get_libdir)/lib{crypto,ssl}.so.0.9.{6,7}
}

pkg_postinst() {
	preserve_old_lib_notify /usr/$(get_libdir)/lib{crypto,ssl}.so.0.9.{6,7}
}
