# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6..9} )
PYTHON_REQ_USE="threads(+),xml(+)"
inherit python-single-r1 waf-utils multilib-minimal linux-info systemd pam tmpfiles

DESCRIPTION="Samba Suite Version 4"
HOMEPAGE="https://samba.org/"

MY_PV="${PV/_rc/rc}"
MY_P="${PN}-${MY_PV}"
if [[ ${PV} = *_rc* ]]; then
	SRC_URI="mirror://samba/rc/${MY_P}.tar.gz"
else
	SRC_URI="mirror://samba/stable/${MY_P}.tar.gz"
	KEYWORDS="*"
fi
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-3"
SLOT="0"
IUSE="acl addc ads ceph client cluster cups debug dmapi fam glusterfs
gpg iprint json ldap pam profiling-data python quota regedit selinux
snapper spotlight syslog system-heimdal +system-mitkrb5 systemd test winbind
zeroconf"

REQUIRED_USE="${PYTHON_REQUIRED_USE}
	addc? ( python json winbind )
	ads? ( acl ldap winbind )
	cluster? ( ads )
	gpg? ( addc )
	spotlight? ( json )
	test? ( python )
	!ads? ( !addc )
	?? ( system-heimdal system-mitkrb5 )
"

# the test suite is messed, it uses system-installed samba
# bits instead of what was built, tests things disabled via use
# flags, and generally just fails to work in a way ebuilds could
# rely on in its current state
RESTRICT="test"

MULTILIB_WRAPPED_HEADERS=(
	/usr/include/samba-4.0/policy.h
	/usr/include/samba-4.0/dcerpc_server.h
	/usr/include/samba-4.0/ctdb.h
	/usr/include/samba-4.0/ctdb_client.h
	/usr/include/samba-4.0/ctdb_protocol.h
	/usr/include/samba-4.0/ctdb_private.h
	/usr/include/samba-4.0/ctdb_typesafe_cb.h
	/usr/include/samba-4.0/ctdb_version.h
)

COMMON_DEPEND="
	>=app-arch/libarchive-3.1.2[${MULTILIB_USEDEP}]
	dev-lang/perl:=
	dev-libs/libbsd[${MULTILIB_USEDEP}]
	dev-libs/libtasn1[${MULTILIB_USEDEP}]
	dev-libs/popt[${MULTILIB_USEDEP}]
	dev-perl/Parse-Yapp
	>=net-libs/gnutls-3.4.7[${MULTILIB_USEDEP}]
	sys-libs/e2fsprogs-libs[${MULTILIB_USEDEP}]
	>=sys-libs/ldb-2.4.1[ldap(+)?,python?,${PYTHON_SINGLE_USEDEP},${MULTILIB_USEDEP}]
	<sys-libs/ldb-2.5.0[ldap(+)?,python?,${PYTHON_SINGLE_USEDEP},${MULTILIB_USEDEP}]
	sys-libs/libcap[${MULTILIB_USEDEP}]
	sys-libs/ncurses:0=
	sys-libs/readline:0=
	>=sys-libs/talloc-2.3.3[python?,${PYTHON_SINGLE_USEDEP},${MULTILIB_USEDEP}]
	>=sys-libs/tdb-1.4.4[python?,${PYTHON_SINGLE_USEDEP},${MULTILIB_USEDEP}]
	>=sys-libs/tevent-0.11.0[python?,${PYTHON_SINGLE_USEDEP},${MULTILIB_USEDEP}]
	sys-libs/zlib[${MULTILIB_USEDEP}]
	virtual/libcrypt:=[${MULTILIB_USEDEP}]
	virtual/libiconv
	addc? (
		$(python_gen_cond_dep 'dev-python/dnspython:=[${PYTHON_USEDEP}]')
		$(python_gen_cond_dep 'dev-python/markdown:=[${PYTHON_USEDEP}]')
	)
	acl? ( virtual/acl )
	ceph? ( sys-cluster/ceph )
	cluster? ( net-libs/rpcsvc-proto )
	cups? ( net-print/cups )
	debug? ( dev-util/lttng-ust )
	dmapi? ( sys-apps/dmapi )
	fam? ( virtual/fam )
	gpg? ( app-crypt/gpgme )
	json? ( dev-libs/jansson:= )
	ldap? ( net-nds/openldap[${MULTILIB_USEDEP}] )
	pam? ( sys-libs/pam )
	snapper? ( sys-apps/dbus )
	system-heimdal? ( >=app-crypt/heimdal-1.5[-ssl,${MULTILIB_USEDEP}] )
	system-mitkrb5? ( >=app-crypt/mit-krb5-1.15.1[${MULTILIB_USEDEP}] )
	systemd? ( sys-apps/systemd:0= )
	zeroconf? ( net-dns/avahi[dbus] )
"
DEPEND="${COMMON_DEPEND}
	>=dev-util/cmocka-1.1.3[${MULTILIB_USEDEP}]
	net-libs/libtirpc[${MULTILIB_USEDEP}]
	|| (
		net-libs/rpcsvc-proto
		<sys-libs/glibc-2.26[rpc(+)]
	)
	spotlight? ( dev-libs/glib )
	test? (
		$(python_gen_cond_dep "dev-python/subunit[\${PYTHON_USEDEP},${MULTILIB_USEDEP}]" )
		!system-mitkrb5? (
			>=net-dns/resolv_wrapper-1.1.4
			>=net-libs/socket_wrapper-1.1.9
			>=sys-libs/nss_wrapper-1.1.3
			>=sys-libs/uid_wrapper-1.2.1
		)
	)"
RDEPEND="${COMMON_DEPEND}
	chromeos-base/chrome-icu:=
	client? ( net-fs/cifs-utils[ads?] )
	python? ( ${PYTHON_DEPS} )
	selinux? ( sec-policy/selinux-samba )
"
BDEPEND="${PYTHON_DEPS}
	app-text/docbook-xsl-stylesheets
	dev-libs/libxslt
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}/${PN}-4.4.0-pam.patch"

	# Chrome OS specific patches that aren't upstream
	"${FILESDIR}/${PN}-4.11.13-machinepass_stdin.patch"
	"${FILESDIR}/${PN}-4.11.13-machinepass_expire.patch"
	"${FILESDIR}/${PN}-4.11.13-reuse_existing_computer_account.patch"

	# Temporary workaround until we fix Samba/OpenLDAP issues (see
	# https://crbug.com/953613).
	"${FILESDIR}/${PN}-4.11.13-lib-gpo-Cope-with-Site-GPO-s-list-failure.patch"
)

#CONFDIR="${FILESDIR}/$(get_version_component_range 1-2)"
CONFDIR="${FILESDIR}/4.4"

WAF_BINARY="${S}/buildtools/bin/waf"

SHAREDMODS=""

pkg_setup() {
	# Package fails to build with distcc
	export DISTCC_DISABLE=1

	PERLVER=$(/usr/bin/perl -e "\$_ = \$^V; s/v//; print")

	python-single-r1_pkg_setup

	SHAREDMODS="$(usex snapper '' '!')vfs_snapper"
	if use cluster ; then
		SHAREDMODS+=",idmap_rid,idmap_tdb2,idmap_ad"
	elif use ads ; then
		SHAREDMODS+=",idmap_ad"
	fi
}

src_prepare() {
	default

	# un-bundle dnspython
	sed -i -e '/"dns.resolver":/d' "${S}"/third_party/wscript || die

	# unbundle iso8601 unless tests are enabled
	if ! use test ; then
		sed -i -e '/"iso8601":/d' "${S}"/third_party/wscript || die
	fi

	## ugly hackaround for bug #592502
	#cp /usr/include/tevent_internal.h "${S}"/lib/tevent/ || die

	sed -e 's:<gpgme\.h>:<gpgme/gpgme.h>:' \
		-i source4/dsdb/samdb/ldb_modules/password_hash.c \
		|| die

	# Friggin' WAF shit
	multilib_copy_sources
}

multilib_src_configure() {
	# when specifying libs for samba build you must append NONE to the end to
	# stop it automatically including things
	local bundled_libs="NONE"
	if ! use system-heimdal && ! use system-mitkrb5 ; then
		bundled_libs="heimbase,heimntlm,hdb,kdc,krb5,wind,gssapi,hcrypto,hx509,roken,asn1,com_err,NONE"
	fi

	local myconf=(
		--enable-fhs
		--sysconfdir="${EPREFIX}/etc"
		--localstatedir="${EPREFIX}/var"
		--with-modulesdir="${EPREFIX}/usr/$(get_libdir)/samba"
		--with-piddir="${EPREFIX}/run/${PN}"
		--bundled-libraries="${bundled_libs}"
		--builtin-libraries=NONE
		--disable-rpath
		--disable-rpath-install
		--nopyc
		--nopyo
		--without-winexe
		--with-libiconv="${SYSROOT}/usr"
		$(multilib_native_use_with acl acl-support)
		$(multilib_native_usex addc '' '--without-ad-dc')
		$(multilib_native_use_with ads)
		$(multilib_native_use_enable ceph cephfs)
		$(multilib_native_use_with cluster cluster-support)
		$(multilib_native_use_enable cups)
		$(multilib_native_use_with dmapi)
		$(multilib_native_use_with fam)
		$(multilib_native_use_enable glusterfs)
		$(multilib_native_use_with gpg gpgme)
		$(multilib_native_use_with json)
		$(multilib_native_use_enable iprint)
		$(multilib_native_use_with pam)
		$(multilib_native_usex pam "--with-pammodulesdir=${EPREFIX}/$(get_libdir)/security" '')
		$(multilib_native_use_with quota quotas)
		$(multilib_native_use_with regedit)
		$(multilib_native_use_enable spotlight)
		$(multilib_native_use_with syslog)
		$(multilib_native_use_with systemd)
		--with-systemddir="$(systemd_get_systemunitdir)"
		$(multilib_native_use_with winbind)
		$(multilib_native_usex python '' '--disable-python')
		$(multilib_native_use_enable zeroconf avahi)
		$(multilib_native_usex test '--enable-selftest' '')
		$(usex system-mitkrb5 "--with-system-mitkrb5 $(multilib_native_usex addc --with-experimental-mit-ad-dc '')" '')
		$(use_with debug lttng)
		$(use_with ldap)
		$(use_with profiling-data)
		# bug #683148
		--jobs 1
	)

	if multilib_is_native_abi ; then
		myconf+=( --with-shared-modules="${SHAREDMODS}" )
	else
		myconf+=( "--with-shared-modules=DEFAULT !vfs_snapper" )
	fi

	KRB5_CONFIG="${CHOST}-krb5-config" \
	PERL5LIB="${SYSROOT}/usr/$(get_libdir)/perl5/vendor_perl/${PERLVER}" \
	YAPP="${SYSROOT}/usr/bin/yapp" \
	CPPFLAGS="-I${SYSROOT}${EPREFIX}/usr/include/et ${CPPFLAGS}" \
		waf-utils_src_configure "${myconf[@]}"
}

multilib_src_compile() {
	PERL5LIB="${SYSROOT}/usr/$(get_libdir)/perl5/vendor_perl/${PERLVER}" \
	YAPP="${SYSROOT}/usr/bin/yapp" \
		waf-utils_src_compile
}

multilib_src_install() {
	waf-utils_src_install

	# Make all .so files executable
	find "${ED}" -type f -name "*.so" -exec chmod +x {} + || die

	# Install async dns plugin only for amd64 architecture for authpolicyd and kerberosd
	if [[ "${ARCH}" == "amd64" ]]; then
		insinto "/usr/$(get_libdir)/krb5/plugins/libkrb5/"
		newins bin/default/nsswitch/libasync-dns-krb5-locator.inst.so libasync-dns-krb5-locator.so
	fi

	if multilib_is_native_abi ; then
		# install ldap schema for server (bug #491002)
		if use ldap ; then
			insinto /etc/openldap/schema
			doins examples/LDAP/samba.schema
		fi

		# create symlink for cups (bug #552310)
		if use cups ; then
			dosym ../../../bin/smbspool /usr/libexec/cups/backend/smb
		fi

		# install example config file
		insinto /etc/samba
		doins examples/smb.conf.default

		# Fix paths in example file (#603964)
		sed \
			-e '/log file =/s@/usr/local/samba/var/@/var/log/samba/@' \
			-e '/include =/s@/usr/local/samba/lib/@/etc/samba/@' \
			-e '/path =/s@/usr/local/samba/lib/@/var/lib/samba/@' \
			-e '/path =/s@/usr/local/samba/@/var/lib/samba/@' \
			-e '/path =/s@/usr/spool/samba@/var/spool/samba@' \
			-i "${ED}"/etc/samba/smb.conf.default || die

		# Install init script and conf.d file
		newinitd "${CONFDIR}/samba4.initd-r1" samba
		newconfd "${CONFDIR}/samba4.confd" samba

		dotmpfiles "${FILESDIR}"/samba.conf
	fi

	if use pam && use winbind ; then
		newpamd "${CONFDIR}/system-auth-winbind.pam" system-auth-winbind
		# bugs #376853 and #590374
		insinto /etc/security
		doins examples/pam_winbind/pam_winbind.conf
	fi

	# Prune directories that maintain state for the samba daemon. If you wish to
	# use the daemon in tests you can pass the private dir as a directive.
	rmdir "${D}"/var/run/samba
	rmdir "${D}"/var/log/samba
	rmdir "${D}"/var/lock/samba
	rm -rf "${D}"/var/lib/samba
	rmdir "${D}"/var/cache/samba

	# Prune empty dirs to avoid tripping multilib checks.
	rmdir "${D}"/usr/lib* 2>/dev/null

	# Move smbd to /usr/local/sbin/smbd to facilitate local testing.
	# This directory is only available on test images, see:
	# https://chromium.googlesource.com/chromiumos/platform2/+/refs/heads/main/dev-install/README.md#Environments
	into /usr/local
	dosbin "${D}"/usr/sbin/smbd
}

multilib_src_test() {
	if multilib_is_native_abi ; then
		"${WAF_BINARY}" test || die "test failed"
	fi
}

pkg_postinst() {
	tmpfiles_process samba.conf

	if [[ -z ${REPLACING_VERSIONS} ]] ; then
		elog "Be aware that this release contains the best of all of Samba's"
		elog "technology parts, both a file server (that you can reasonably expect"
		elog "to upgrade existing Samba 3.x releases to) and the AD domain"
		elog "controller work previously known as 'samba4'."
		elog
	fi
	if [[ "${PV}" != *_rc* ]] ; then
		elog "For further information and migration steps make sure to read "
		elog "https://samba.org/samba/history/${P}.html "
		elog "https://wiki.samba.org/index.php/Samba4/HOWTO "
	fi
}
