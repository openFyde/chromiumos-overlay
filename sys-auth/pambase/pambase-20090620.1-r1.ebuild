# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-auth/pambase/pambase-20090620.1-r1.ebuild,v 1.7 2009/10/09 19:22:35 maekke Exp $

EAPI=2

inherit eutils

DESCRIPTION="PAM base configuration files"
HOMEPAGE="http://www.gentoo.org/proj/en/base/pam/"
SRC_URI="http://www.flameeyes.eu/gentoo-distfiles/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm hppa ~ia64 ~m68k ~mips ppc ppc64 ~s390 ~sh ~sparc x86 ~sparc-fbsd ~x86-fbsd"
IUSE="debug cracklib passwdqc consolekit gnome-keyring selinux mktemp ssh +sha512"
RESTRICT="binchecks"

RDEPEND="
	|| (
		>=sys-libs/pam-0.99.9.0-r1
		( sys-auth/openpam
		  || ( sys-freebsd/freebsd-pam-modules sys-netbsd/netbsd-pam-modules )
		)
	)
	cracklib? ( >=sys-libs/pam-0.99[cracklib] )
	consolekit? ( >=sys-auth/consolekit-0.3[pam] )
	gnome-keyring? ( >=gnome-base/gnome-keyring-2.20[pam] )
	selinux? ( >=sys-libs/pam-0.99[selinux] )
	passwdqc? ( >=sys-auth/pam_passwdqc-1.0.4 )
	mktemp? ( sys-auth/pam_mktemp )
	ssh? ( sys-auth/pam_ssh )
	sha512? ( >=sys-libs/pam-1.0.1 )
	!<sys-freebsd/freebsd-pam-modules-6.2-r1
	!<sys-libs/pam-0.99.9.0-r1"
DEPEND="app-portage/portage-utils"

src_prepare() {
	# Disable nullok option.
	epatch "${FILESDIR}/${P}-disable-nullok.patch"
}

src_compile() {
	local implementation=
	local linux_pam_version=
	if has_version sys-libs/pam; then
		implementation="linux-pam"
		local ver_str=$(qatom `best_version sys-libs/pam` | cut -d ' ' -f 3)
		linux_pam_version=$(printf "0x%02x%02x%02x" ${ver_str//\./ })
	elif has_version sys-auth/openpam; then
		implementation="openpam"
	else
		die "PAM implementation not identified"
	fi

	use_var() {
		local varname=$(echo $1 | tr [a-z] [A-Z])
		local usename=${2-$(echo $1 | tr [A-Z] [a-z])}
		local varvalue=$(use $usename && echo yes || echo no)
		echo "${varname}=${varvalue}"
	}

	emake \
		GIT=true \
		$(use_var debug) \
		$(use_var cracklib) \
		$(use_var passwdqc) \
		$(use_var consolekit) \
		$(use_var GNOME_KEYRING gnome-keyring) \
		$(use_var selinux) \
		$(use_var mktemp) \
		$(use_var PAM_SSH ssh) \
		$(use_var sha512) \
		IMPLEMENTATION=${implementation} \
		LINUX_PAM_VERSION=${linux_pam_version} \
		|| die "emake failed"
}

src_install() {
	emake GIT=true DESTDIR="${D}" install || die "emake install failed"

	# Chrome OS: sudo and vt2 are important for system debugging both in
	# developer mode and during development.  These two stanzas allow sudo and
	# login auth as user chronos under the following conditions:
	#
	# 1. password-less access:
	# - system in developer mode
	# - there is no passwd.devmode file
	# - there is no system-wide password set above.
	# 2. System-wide (/etc/shadow) password access:
	# - image has a baked in password above
	# 3. Developer mode password access
	# - user creates a passwd.devmode file with "chronos:CRYPTED_PASSWORD"
	# 4. System-wide (/etc/shadow) password access set by modifying /etc/shadow:
	# - Cases #1 and #2 will apply but failure will fall through to the
	#   inserted password.
	insinto /etc/pam.d
	doins "${FILESDIR}/chromeos-auth" || die
}

pkg_postinst() {
	# If there's a shared user password or if the build target is the host,
	# reset chromeos-auth to an empty file. We don't transition from empty to
	# populated because binary packages lose FILESDIR.
	local crypted_password='*'
	if [ "${ROOT}" = "/" ]; then
		crypted_password='host'
	else
		[ -r "${SHARED_USER_PASSWD_FILE}" ] &&
			crypted_password=$(cat "${SHARED_USER_PASSWD_FILE}")
	fi
	if [ "${crypted_password}" != '*' ]; then
		echo -n '' > "${ROOT}/etc/pam.d/chromeos-auth" || die
	fi

	if use sha512; then
		elog "Starting from version 20080801, pambase optionally enables"
		elog "SHA512-hashed passwords. For this to work, you need sys-libs/pam-1.0.1"
		elog "built against sys-libs/glibc-2.7 or later."
		elog "If you don't have support for this, it will automatically fallback"
		elog "to MD5-hashed passwords, just like before."
		elog
		elog "Please note that the change only affects the newly-changed passwords"
		elog "and that SHA512-hashed passwords will not work on earlier versions"
		elog "of glibc or Linux-PAM."
	fi
}
