# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-libs/glibc/glibc-9999.ebuild,v 1.16 2012/11/02 18:25:11 vapier Exp $

inherit eutils versionator toolchain-funcs flag-o-matic gnuconfig multilib unpacker multiprocessing binutils-funcs

DESCRIPTION="GNU libc6 (also called glibc2) C library"
HOMEPAGE="http://www.gnu.org/software/libc/libc.html"

LICENSE="LGPL-2"
#KEYWORDS="~amd64 ~ia64 ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
RESTRICT="strip" # strip ourself #46186
EMULTILIB_PKG="true"

# Configuration variables
RELEASE_VER=""
case ${PV} in
9999*)
	EGIT_REPO_URIS=( "git://sourceware.org/git/glibc.git" "git://sourceware.org/git/glibc-ports.git" )
	EGIT_SOURCEDIRS=( "${S}" "${S}/ports" )
	inherit git-2
	;;
*)
	RELEASE_VER=${PV}
	;;
esac
PATCH_VER=""                                   # Gentoo patchset
PORTS_VER=${RELEASE_VER}                       # version of glibc ports addon
NPTL_KERN_VER=${NPTL_KERN_VER:-"2.6.9"}        # min kernel version nptl requires

IUSE="debug gd hardened multilib selinux systemtap profile vanilla crosscompile_opts_headers-only"

# Here's how the cross-compile logic breaks down ...
#  CTARGET - machine that will target the binaries
#  CHOST   - machine that will host the binaries
#  CBUILD  - machine that will build the binaries
# If CTARGET != CHOST, it means you want a libc for cross-compiling.
# If CHOST != CBUILD, it means you want to cross-compile the libc.
#  CBUILD = CHOST = CTARGET    - native build/install
#  CBUILD != (CHOST = CTARGET) - cross-compile a native build
#  (CBUILD = CHOST) != CTARGET - libc for cross-compiler
#  CBUILD != CHOST != CTARGET  - cross-compile a libc for a cross-compiler
# For install paths:
#  CHOST = CTARGET  - install into /
#  CHOST != CTARGET - install into /usr/CTARGET/

export CBUILD=${CBUILD:-${CHOST}}
export CTARGET=${CTARGET:-${CHOST}}
if [[ ${CTARGET} == ${CHOST} ]] ; then
	if [[ ${CATEGORY} == cross-* ]] ; then
		export CTARGET=${CATEGORY#cross-}
	fi
fi

[[ ${CTARGET} == hppa* ]] && NPTL_KERN_VER=${NPTL_KERN_VER/2.6.9/2.6.20}

is_crosscompile() {
	[[ ${CHOST} != ${CTARGET} ]]
}

# Why SLOT 2.2 you ask yourself while sippin your tea ?
# Everyone knows 2.2 > 0, duh.
SLOT="2.2"

# General: We need a new-enough binutils/gcc to match upstream baseline.
# arch: we need to make sure our binutils/gcc supports TLS.
DEPEND=">=app-misc/pax-utils-0.1.10
	!<sys-apps/sandbox-1.6
	!<sys-apps/portage-2.1.2
	selinux? ( sys-libs/libselinux )"
RDEPEND="!sys-kernel/ps3-sources
	selinux? ( sys-libs/libselinux )
	!sys-libs/nss-db"

if [[ ${CATEGORY} == cross-* ]] ; then
	DEPEND+=" !crosscompile_opts_headers-only? (
		>=${CATEGORY}/binutils-2.20
		>=${CATEGORY}/gcc-4.3
	)"
	[[ ${CATEGORY} == *-linux* ]] && DEPEND+=" ${CATEGORY}/linux-headers"
else
	DEPEND+="
		>=sys-devel/binutils-2.20
		>=sys-devel/gcc-4.3
		virtual/os-headers
		!vanilla? ( >=sys-libs/timezone-data-2012c )"
	RDEPEND+="
		vanilla? ( !sys-libs/timezone-data )
		!vanilla? ( sys-libs/timezone-data )"
fi

SRC_URI=$(
	upstream_uris() {
		echo mirror://gnu/glibc/$1 ftp://sources.redhat.com/pub/glibc/{releases,snapshots}/$1 mirror://gentoo/$1
	}
	gentoo_uris() {
		local devspace="HTTP~vapier/dist/URI HTTP~azarah/glibc/URI"
		devspace=${devspace//HTTP/http://dev.gentoo.org/}
		echo mirror://gentoo/$1 ${devspace//URI/$1}
	}

	[[ -z ${EGIT_REPO_URIS} ]] && upstream_uris ${P}.tar.xz
	[[ -n ${PORTS_VER}     ]] && upstream_uris ${TARNAME}-ports-${PORTS_VER}.tar.bz2
	[[ -n ${PATCH_VER}     ]] && gentoo_uris glibc-${RELEASE_VER}-patches-${PATCH_VER}.tar.bz2
)

# eblit-include [--skip] <function> [version]
eblit-include() {
	local skipable=false
	[[ $1 == "--skip" ]] && skipable=true && shift
	[[ $1 == pkg_* ]] && skipable=true

	local e v func=$1 ver=$2
	[[ -z ${func} ]] && die "Usage: eblit-include <function> [version]"
	for v in ${ver:+-}${ver} -${PVR} -${PV} "" ; do
		e="${FILESDIR}/eblits/${func}${v}.eblit"
		if [[ -e ${e} ]] ; then
			source "${e}"
			return 0
		fi
	done
	${skipable} && return 0
	die "Could not locate requested eblit '${func}' in ${FILESDIR}/eblits/"
}

# eblit-run-maybe <function>
# run the specified function if it is defined
eblit-run-maybe() {
	[[ $(type -t "$@") == "function" ]] && "$@"
}

# eblit-run <function> [version]
# aka: src_unpack() { eblit-run src_unpack ; }
eblit-run() {
	eblit-include --skip common "${*:2}"
	eblit-include "$@"
	eblit-run-maybe eblit-$1-pre
	eblit-${PN}-$1
	eblit-run-maybe eblit-$1-post
}

src_unpack()  { eblit-run src_unpack  ; }
src_compile() { eblit-run src_compile ; }
src_test()    { eblit-run src_test    ; }
src_install() { eblit-run src_install ; }

# FILESDIR might not be available during binpkg install
for x in setup {pre,post}inst ; do
	e="${FILESDIR}/eblits/pkg_${x}.eblit"
	if [[ -e ${e} ]] ; then
		. "${e}"
		eval "pkg_${x}() { eblit-run pkg_${x} ; }"
	fi
done

eblit-src_unpack-post() {
	if use hardened ; then
		cd "${S}"
		einfo "Patching to get working PIE binaries on PIE (hardened) platforms"
		gcc-specs-pie && epatch "${FILESDIR}"/2.12/glibc-2.12-hardened-pie.patch
		epatch "${FILESDIR}"/2.10/glibc-2.10-hardened-configure-picdefault.patch
		epatch "${FILESDIR}"/2.10/glibc-2.10-hardened-inittls-nosysenter.patch

		einfo "Installing Hardened Gentoo SSP and FORTIFY_SOURCE handler"
		cp -f "${FILESDIR}"/2.6/glibc-2.6-gentoo-stack_chk_fail.c \
			debug/stack_chk_fail.c || die
		cp -f "${FILESDIR}"/2.10/glibc-2.10-gentoo-chk_fail.c \
			debug/chk_fail.c || die

		if use debug ; then
			# When using Hardened Gentoo stack handler, have smashes dump core for
			# analysis - debug only, as core could be an information leak
			# (paranoia).
			sed -i \
				-e '/^CFLAGS-backtrace.c/ iCFLAGS-stack_chk_fail.c = -DSSP_SMASH_DUMPS_CORE' \
				debug/Makefile \
				|| die "Failed to modify debug/Makefile for debug stack handler"
			sed -i \
				-e '/^CFLAGS-backtrace.c/ iCFLAGS-chk_fail.c = -DSSP_SMASH_DUMPS_CORE' \
				debug/Makefile \
				|| die "Failed to modify debug/Makefile for debug fortify handler"
		fi

		# Build nscd with ssp-all
		sed -i \
			-e 's:-fstack-protector$:-fstack-protector-all:' \
			nscd/Makefile \
			|| die "Failed to ensure nscd builds with ssp-all"
	fi
}
