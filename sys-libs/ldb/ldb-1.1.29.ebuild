# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="threads"

inherit python-single-r1 waf-utils multilib-minimal eutils

DESCRIPTION="An LDAP-like embedded database"
HOMEPAGE="http://ldb.samba.org"
SRC_URI="http://www.samba.org/ftp/pub/${PN}/${P}.tar.gz"

LICENSE="LGPL-3"
SLOT="0/${PV}"
KEYWORDS="*"
IUSE="doc +ldap"

RDEPEND="!elibc_FreeBSD? ( dev-libs/libbsd[${MULTILIB_USEDEP}] )
	dev-libs/popt[${MULTILIB_USEDEP}]
	>=sys-libs/talloc-2.1.8[python,${MULTILIB_USEDEP}]
	>=sys-libs/tevent-0.9.31[python(+),${MULTILIB_USEDEP}]
	>=sys-libs/tdb-1.3.12[python,${MULTILIB_USEDEP}]
	!!<net-fs/samba-3.6.0[ldb]
	!!>=net-fs/samba-4.0.0[ldb]
	${PYTHON_DEPS}
	ldap? ( net-nds/openldap )
	"

DEPEND="dev-libs/libxslt
	doc? ( app-doc/doxygen )
	virtual/pkgconfig
	${RDEPEND}"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

WAF_BINARY="${S}/buildtools/bin/waf"

MULTILIB_WRAPPED_HEADERS=( /usr/include/pyldb.h )

PATCHES=(
	"${FILESDIR}"/${PN}-1.1.27-optional_packages.patch
)

pkg_setup() {
	python-single-r1_pkg_setup
}

src_prepare() {
	epatch "${PATCHES[@]}"

	multilib_copy_sources
}

multilib_src_configure() {
	local myconf=(
		$(usex ldap '' --disable-ldap) \
		--disable-rpath \
		--disable-rpath-install --bundled-libraries=NONE \
		--with-modulesdir="${EPREFIX}"/usr/$(get_libdir)/samba \
		--builtin-libraries=NONE
	)
	if ! multilib_is_native_abi; then
		myconf+=( --disable-python )
	fi
	waf-utils_src_configure "${myconf[@]}"
}

multilib_src_compile(){
	waf-utils_src_compile
	multilib_is_native_abi && use doc && doxygen Doxyfile
}

multilib_src_test() {
	if multilib_is_native_abi; then
		WAF_MAKE=1 \
		PATH=buildtools/bin:../../../buildtools/bin:$PATH:"${BUILD_DIR}"/bin/shared/private/ \
		LD_LIBRARY_PATH=$LD_LIBRARY_PATH:"${BUILD_DIR}"/bin/shared/private/:"${BUILD_DIR}"/bin/shared \
		waf test || die
	fi
}

multilib_src_install() {
	waf-utils_src_install

	if multilib_is_native_abi && use doc; then
		doman  apidocs/man/man3/*.3
		docinto html
		dodoc -r apidocs/html/*
	fi
}

pkg_postinst() {
	if has_version sys-auth/sssd; then
		ewarn "You have sssd installed. It is known to break after ldb upgrades,"
		ewarn "so please try to rebuild it before reporting bugs."
		ewarn "See https://bugs.gentoo.org/404281"
	fi
}
