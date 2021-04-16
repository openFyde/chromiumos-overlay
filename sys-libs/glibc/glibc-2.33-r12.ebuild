# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8,9} )

inherit python-any-r1 prefix eutils toolchain-funcs flag-o-matic gnuconfig \
	multilib systemd multiprocessing

DESCRIPTION="GNU libc C library"
HOMEPAGE="https://www.gnu.org/software/libc/"
LICENSE="LGPL-2.1+ BSD HPND ISC inner-net rc PCRE"
SLOT="2.2"

EMULTILIB_PKG="true"

# Gentoo patchset (ignored for live ebuilds)
PATCH_VER=6
PATCH_DEV=dilfridge

if [[ ${PV} == 9999* ]]; then
	inherit git-r3
else
	KEYWORDS="*"
	SRC_URI="mirror://gnu/glibc/${P}.tar.xz"
	SRC_URI+=" https://dev.gentoo.org/~${PATCH_DEV}/distfiles/${P}-patches-${PATCH_VER}.tar.xz"
fi

RELEASE_VER=${PV}

GCC_BOOTSTRAP_VER=20201208

LOCALE_GEN_VER=2.10

SRC_URI+=" https://gitweb.gentoo.org/proj/locale-gen.git/snapshot/locale-gen-${LOCALE_GEN_VER}.tar.gz"
SRC_URI+=" multilib-bootstrap? ( https://dev.gentoo.org/~dilfridge/distfiles/gcc-multilib-bootstrap-${GCC_BOOTSTRAP_VER}.tar.xz )"

IUSE="audit caps cet compile-locales crypt custom-cflags doc gd headers-only +multiarch multilib multilib-bootstrap nscd profile selinux +ssp +static-libs static-pie suid systemtap test vanilla crosscompile_opts_headers-only"

# Minimum kernel version that glibc requires
MIN_KERN_VER="3.2.0"

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
#
export CBUILD=${CBUILD:-${CHOST}}
export CTARGET=${CTARGET:-${CHOST}}
if [[ ${CTARGET} == ${CHOST} ]] ; then
	if [[ ${CATEGORY} == cross-* ]] ; then
		export CTARGET=${CATEGORY#cross-}
	fi
fi

# Note [Disable automatic stripping]
# Disabling automatic stripping for a few reasons:
# - portage's attempt to strip breaks non-native binaries at least on
#   arm: bug #697428
# - portage's attempt to strip libpthread.so.0 breaks gdb thread
#   enumeration: bug #697910. This is quite subtle:
#   * gdb uses glibc's libthread_db-1.0.so to enumerate threads.
#   * libthread_db-1.0.so needs access to libpthread.so.0 local symbols
#     via 'ps_pglobal_lookup' symbol defined in gdb.
#   * 'ps_pglobal_lookup' uses '.symtab' section table to resolve all
#     known symbols in 'libpthread.so.0'. Specifically 'nptl_version'
#     (unexported) is used to sanity check compatibility before enabling
#     debugging.
#     Also see https://sourceware.org/gdb/wiki/FAQ#GDB_does_not_see_any_threads_besides_the_one_in_which_crash_occurred.3B_or_SIGTRAP_kills_my_program_when_I_set_a_breakpoint
#   * normal 'strip' command trims '.symtab'
#   Thus our main goal here is to prevent 'libpthread.so.0' from
#   losing it's '.symtab' entries.
# As Gentoo's strip does not allow us to pass less aggressive stripping
# options and does not check the machine target we strip selectively.

# We need a new-enough binutils/gcc to match upstream baseline.
# Also we need to make sure our binutils/gcc supports TLS,
# and that gcc already contains the hardened patches.
# Lastly, let's avoid some openssh nastiness, bug 708224, as
# convenience to our users.

# gzip, grep, awk are needed by locale-gen, bug 740750

BDEPEND="
	${PYTHON_DEPS}
	>=app-misc/pax-utils-0.1.10
	sys-devel/bison
	doc? ( sys-apps/texinfo )
	!compile-locales? (
		app-arch/gzip
		sys-apps/grep
		virtual/awk
	)
"
COMMON_DEPEND="
	gd? ( media-libs/gd:2= )
	nscd? ( selinux? (
		audit? ( sys-process/audit )
		caps? ( sys-libs/libcap )
	) )
	suid? ( caps? ( sys-libs/libcap ) )
	selinux? ( sys-libs/libselinux )
	systemtap? ( dev-util/systemtap )
	!<net-misc/openssh-8.1_p1-r2
"
DEPEND="${COMMON_DEPEND}
	compile-locales? (
		app-arch/gzip
		sys-apps/grep
		virtual/awk
	)
	test? ( >=net-dns/libidn2-2.3.0 )
"
# Crosbug 1190403: The PDEPEND -> RDEPEND divergence between CrOS and Gentoo is intentional
PDEPEND="${COMMON_DEPEND}
	app-arch/gzip
	sys-apps/grep
	virtual/awk
	sys-apps/gentoo-functions
"

RESTRICT="!test? ( test )"

if [[ ${CATEGORY} == cross-* ]] ; then
	BDEPEND+=" !headers-only? (
		!crosscompile_opts_headers-only? (
			>=${CATEGORY}/binutils-2.27
			>=${CATEGORY}/gcc-6
			)
	)"
	[[ ${CATEGORY} == *-linux* ]] && DEPEND+=" ${CATEGORY}/linux-headers"
else
	BDEPEND+="
		>=sys-devel/binutils-2.27
		>=sys-devel/gcc-6
	"
	DEPEND+=" virtual/os-headers "
	RDEPEND+="
		>=net-dns/libidn2-2.3.0
		vanilla? ( !sys-libs/timezone-data )
	"
	PDEPEND+=" !vanilla? ( sys-libs/timezone-data )"
fi

# Ignore tests allowlisted below
GENTOO_GLIBC_XFAIL_TESTS="${GENTOO_GLIBC_XFAIL_TESTS:-yes}"

# The following tests fail due to the Gentoo build system and are thus
# executed but ignored:
XFAIL_TEST_LIST=(
	# 9) Failures of unknown origin
	tst-latepthread

	# buggy test, assumes /dev/ and /dev/null on a single filesystem
	# 'mount --bind /dev/null /chroot/dev/null' breaks it.
	# https://sourceware.org/PR25909
	tst-support_descriptors

	# Flaky test, known to fail occasionally:
	# https://sourceware.org/PR19329
	# https://bugs.gentoo.org/719674#c12
	tst-stack4
)

#
# Small helper functions
#

is_crosscompile() {
	[[ ${CHOST} != ${CTARGET} ]]
}

just_headers() {
	is_crosscompile && ( use headers-only || use crosscompile_opts_headers-only )
}

alt_prefix() {
	is_crosscompile && echo /usr/${CTARGET}
}

# This prefix is applicable to CHOST when building against this
# glibc. It is baked into the library at configure time.
host_eprefix() {
	is_crosscompile || echo "${EPREFIX}"
}

# This prefix is applicable to CBUILD when building against this
# glibc. It determines the destination path at install time.
build_eprefix() {
	is_crosscompile && echo "${EPREFIX}"
}

# We need to be able to set alternative headers for compiling for non-native
# platform. Will also become useful for testing kernel-headers without screwing
# up the whole system.
alt_headers() {
	echo ${ALT_HEADERS:=$(alt_prefix)/usr/include}
}

alt_build_headers() {
	if [[ -z ${ALT_BUILD_HEADERS} ]] ; then
		ALT_BUILD_HEADERS="$(host_eprefix)$(alt_headers)"
		if tc-is-cross-compiler ; then
			ALT_BUILD_HEADERS=${SYSROOT}$(alt_headers)
			if [[ ! -e ${ALT_BUILD_HEADERS}/linux/version.h ]] ; then
				local header_path=$(echo '#include <linux/version.h>' | $(tc-getCPP ${CTARGET}) ${CFLAGS} 2>&1 | grep -o '[^"]*linux/version.h')
				ALT_BUILD_HEADERS=${header_path%/linux/version.h}
			fi
		fi
	fi
	echo "${ALT_BUILD_HEADERS}"
}

alt_libdir() {
	echo $(alt_prefix)/$(get_libdir)
}
alt_usrlibdir() {
	echo $(alt_prefix)/usr/$(get_libdir)
}

builddir() {
	echo "${WORKDIR}/build-${ABI}-${CTARGET}-$1"
}

do_compile_test() {
	local ret save_cflags=${CFLAGS}
	CFLAGS+=" $1"
	shift

	pushd "${T}" >/dev/null

	rm -f glibc-test*
	printf '%b' "$*" > glibc-test.c

	# Most of the time CC is already set, but not in early sanity checks.
	nonfatal emake glibc-test CC="${CC-$(tc-getCC ${CTARGET})}"
	ret=$?

	popd >/dev/null

	CFLAGS=${save_cflags}
	return ${ret}
}

do_run_test() {
	local ret

	if [[ ${MERGE_TYPE} == "binary" ]] ; then
		# ignore build failures when installing a binary package #324685
		do_compile_test "" "$@" 2>/dev/null || return 0
	else
		if ! do_compile_test "" "$@" ; then
			ewarn "Simple build failed ... assuming this is desired #324685"
			return 0
		fi
	fi

	pushd "${T}" >/dev/null

	./glibc-test
	ret=$?
	rm -f glibc-test*

	popd >/dev/null

	return ${ret}
}

setup_target_flags() {
	# This largely mucks with compiler flags.  None of which should matter
	# when building up just the headers.
	just_headers && return 0

	# Needed as workaround to fix:
	# http://code.google.com/p/chromium-os/issues/detail?id=22373
	# Can be removed when we emerge glibc to the target:
	# http://code.google.com/p/chromium-os/issues/detail?id=20792
	append-cflags "-ggdb"

	# ChromiumOS: Need to unset the SYSROOT value so that the
	# compiler uses the default sysroot when building glibc. This
	# is because the glibc startup objects are needed to configure
	# glibc. We don't want to bootstrap libc again.
	export SYSROOT=""

	case $(tc-arch) in
		x86)
			# -march needed for #185404 #199334
			# TODO: When creating the first glibc cross-compile, this test will
			# always fail as it does a full link which in turn requires glibc.
			# Probably also applies when changing multilib profile settings (e.g.
			# enabling x86 when the profile was amd64-only previously).
			# We could change main to _start and pass -nostdlib here so that we
			# only test the gcc code compilation.  Or we could do a compile and
			# then look for the symbol via scanelf.
			if ! do_compile_test "" 'void f(int i, void *p) {if (__sync_fetch_and_add(&i, 1)) f(i, p);}\nint main(){return 0;}\n'; then
				local t=${CTARGET_OPT:-${CTARGET}}
				t=${t%%-*}
				filter-flags '-march=*'
				export CFLAGS="-march=${t} ${CFLAGS}"
				einfo "Auto adding -march=${t} to CFLAGS #185404"
			fi
		;;
		amd64)
			# -march needed for #185404 #199334
			# TODO: See cross-compile issues listed above for x86.
			[[ ${ABI} == x86 ]] &&
			if ! do_compile_test "${CFLAGS_x86}" 'void f(int i, void *p) {if (__sync_fetch_and_add(&i, 1)) f(i, p);}\nint main(){return 0;}\n'; then
				local t=${CTARGET_OPT:-${CTARGET}}
				t=${t%%-*}
				# Normally the target is x86_64-xxx, so turn that into the -march that
				# gcc actually accepts. #528708
				[[ ${t} == "x86_64" ]] && t="x86-64"
				filter-flags '-march=*'
				# ugly, ugly, ugly.  ugly.
				CFLAGS_x86=$(CFLAGS=${CFLAGS_x86} filter-flags '-march=*'; echo "${CFLAGS}")
				export CFLAGS_x86="${CFLAGS_x86} -march=${t}"
				einfo "Auto adding -march=${t} to CFLAGS_x86 #185404 (ABI=${ABI})"
			fi
		;;
		mips)
			# The mips abi cannot support the GNU style hashes. #233233
			filter-ldflags -Wl,--hash-style=gnu -Wl,--hash-style=both
		;;
		ppc|ppc64)
			# Many arch-specific implementations do not work on ppc with
			# cache-block not equal to 128 bytes. This breaks memset:
			#   https://sourceware.org/PR26522
			#   https://bugs.gentoo.org/737996
			# Use default -mcpu=. For ppc it means non-multiarch setup.
			filter-flags '-mcpu=*'
		;;
		sparc)
			# Both sparc and sparc64 can use -fcall-used-g6.  -g7 is bad, though.
			filter-flags "-fcall-used-g7"
			append-flags "-fcall-used-g6"

			local cpu
			case ${CTARGET} in
			sparc64-*)
				cpu="sparc64"
				case $(get-flag mcpu) in
				v9)
					# We need to force at least v9a because the base build doesn't
					# work with just v9.
					# https://sourceware.org/bugzilla/show_bug.cgi?id=19477
					append-flags "-Wa,-xarch=v9a"
					;;
				esac
				;;
			sparc-*)
				case $(get-flag mcpu) in
				v8|supersparc|hypersparc|leon|leon3)
					cpu="sparcv8"
					;;
				*)
					cpu="sparcv9"
					;;
				esac
			;;
			esac
			[[ -n ${cpu} ]] && CTARGET_OPT="${cpu}-${CTARGET#*-}"
		;;
	esac
}

setup_flags() {
	# Glibc controls its own optimization settings, so this would be a nop
	# if we were to run it. Leave it here anyway as a grep-friendly marker.
	# cros_optimize_package_for_speed

	# Make sure host make.conf doesn't pollute us
	if is_crosscompile || tc-is-cross-compiler ; then
		CHOST=${CTARGET} strip-unsupported-flags
	fi

	# Store our CFLAGS because it's changed depending on which CTARGET
	# we are building when pulling glibc on a multilib profile
	CFLAGS_BASE=${CFLAGS_BASE-${CFLAGS}}
	CFLAGS=${CFLAGS_BASE}
	CXXFLAGS_BASE=${CXXFLAGS_BASE-${CXXFLAGS}}
	CXXFLAGS=${CXXFLAGS_BASE}
	ASFLAGS_BASE=${ASFLAGS_BASE-${ASFLAGS}}
	ASFLAGS=${ASFLAGS_BASE}

	# Allow users to explicitly avoid flag sanitization via
	# USE=custom-cflags.
	if ! use custom-cflags; then
		# Over-zealous CFLAGS can often cause problems.  What may work for one
		# person may not work for another.  To avoid a large influx of bugs
		# relating to failed builds, we strip most CFLAGS out to ensure as few
		# problems as possible.
		strip-flags
		# Lock glibc at -O2; we want to be conservative here.
		filter-flags '-O?'
		append-flags -O2
	fi
	strip-unsupported-flags
	filter-flags -m32 -m64 '-mabi=*'

	# glibc aborts if rpath is set by LDFLAGS
	filter-ldflags '-Wl,-rpath=*'

	# #492892
	filter-flags -frecord-gcc-switches

	unset CBUILD_OPT CTARGET_OPT
	if use multilib ; then
		CTARGET_OPT=$(get_abi_CTARGET)
		[[ -z ${CTARGET_OPT} ]] && CTARGET_OPT=$(get_abi_CHOST)
	fi

	setup_target_flags

	if [[ -n ${CTARGET_OPT} && ${CBUILD} == ${CHOST} ]] && ! is_crosscompile; then
		CBUILD_OPT=${CTARGET_OPT}
	fi

	# glibc's headers disallow -O0 and fail at build time:
	#  include/libc-symbols.h:75:3: #error "glibc cannot be compiled without optimization"
	replace-flags -O0 -O1

	filter-flags '-fstack-protector*'
}

want_tls() {
	# Archs that can use TLS (Thread Local Storage)
	case $(tc-arch) in
		x86)
			# requires i486 or better #106556
			[[ ${CTARGET} == i[4567]86* ]] && return 0
			return 1
		;;
	esac
	return 0
}

want__thread() {
	want_tls || return 1

	# For some reason --with-tls --with__thread is causing segfaults on sparc32.
	[[ ${PROFILE_ARCH} == "sparc" ]] && return 1

	[[ -n ${WANT__THREAD} ]] && return ${WANT__THREAD}

	# only test gcc -- can't test linking yet
	tc-has-tls -c ${CTARGET}
	WANT__THREAD=$?

	return ${WANT__THREAD}
}

use_multiarch() {
	# Allow user to disable runtime arch detection in multilib.
	use multiarch || return 1
	# Make sure binutils is new enough to support indirect functions,
	# #336792. This funky sed supports gold and bfd linkers.
	local bver nver
	bver=$($(tc-getLD ${CTARGET}) -v | sed -n -r '1{s:[^0-9]*::;s:^([0-9.]*).*:\1:;p}')
	case $(tc-arch ${CTARGET}) in
	amd64|x86) nver="2.20" ;;
	arm)       nver="2.22" ;;
	hppa)      nver="2.23" ;;
	ppc|ppc64) nver="2.20" ;;
	# ifunc support was added in 2.23, but glibc also needs
	# machinemode which is in 2.24.
	s390)      nver="2.24" ;;
	sparc)     nver="2.21" ;;
	*)         return 1 ;;
	esac
	ver_test ${bver} -ge ${nver}
}

# Setup toolchain variables that had historically been defined in the
# profiles for these archs.
setup_env() {
	# silly users
	unset LD_RUN_PATH
	unset LD_ASSUME_KERNEL

	if is_crosscompile || tc-is-cross-compiler ; then
		multilib_env ${CTARGET_OPT:-${CTARGET}}

		if ! use multilib ; then
			MULTILIB_ABIS=${DEFAULT_ABI}
		else
			MULTILIB_ABIS=${MULTILIB_ABIS:-${DEFAULT_ABI}}
		fi

		# If the user has CFLAGS_<CTARGET> in their make.conf, use that,
		# and fall back on CFLAGS.
		local VAR=CFLAGS_${CTARGET//[-.]/_}
		CFLAGS=${!VAR-${CFLAGS}}
		einfo " $(printf '%15s' 'Manual CFLAGS:')   ${CFLAGS}"
	fi

	setup_flags

	export ABI=${ABI:-${DEFAULT_ABI:-default}}

	if just_headers ; then
		# Avoid mixing host's CC and target's CFLAGS_${ABI}:
		# At this bootstrap stage we have only binutils for
		# target but not compiler yet.
		einfo "Skip CC ABI injection. We can't use (cross-)compiler yet."
		return 0
	fi
	local VAR=CFLAGS_${ABI}
	# We need to export CFLAGS with abi information in them because glibc's
	# configure script checks CFLAGS for some targets (like mips).  Keep
	# around the original clean value to avoid appending multiple ABIs on
	# top of each other.

	# For ChromiumOS, the default compiler is clang, we need to set it to gcc.
	: ${__GLIBC_CC:=$(tc-getCC ${CTARGET})}
	export __GLIBC_CC CC="${__GLIBC_CC}"
	cros_use_gcc
	export CC="${CC} ${!VAR}"
	einfo " $(printf '%15s' 'Manual CC:')   ${CC}"
}

foreach_abi() {
	# For ChromiumOS, we need to unset __GLIBC_CC CC here. Otherwise
	# we could not run sudo emerge sys-libs/glibc inside chroot.
	unset __GLIBC_CC CC
	setup_env

	local ret=0
	local abilist=""
	if use multilib ; then
		abilist=$(get_install_abis)
	else
		abilist=${DEFAULT_ABI}
	fi
	local -x ABI
	for ABI in ${abilist:-default} ; do
		setup_env
		einfo "Running $1 for ABI ${ABI}"
		$1
		: $(( ret |= $? ))
	done
	return ${ret}
}

glibc_banner() {
	local b="Gentoo ${PVR}"
	[[ -n ${PATCH_VER} ]] && ! use vanilla && b+=" p${PATCH_VER}"
	echo "${b}"
}

# The following Kernel version handling functions are mostly copied from portage
# source. It's better not to use linux-info.eclass here since a) it adds too
# much magic, see bug 326693 for some of the arguments, and b) some of the
# functions are just not provided.

g_get_running_KV() {
	uname -r
	return $?
}

g_KV_major() {
	[[ -z $1 ]] && return 1
	local KV=$@
	echo "${KV%%.*}"
}

g_KV_minor() {
	[[ -z $1 ]] && return 1
	local KV=$@
	KV=${KV#*.}
	echo "${KV%%.*}"
}

g_KV_micro() {
	[[ -z $1 ]] && return 1
	local KV=$@
	KV=${KV#*.*.}
	echo "${KV%%[^[:digit:]]*}"
}

g_KV_to_int() {
	[[ -z $1 ]] && return 1
	local KV_MAJOR=$(g_KV_major "$1")
	local KV_MINOR=$(g_KV_minor "$1")
	local KV_MICRO=$(g_KV_micro "$1")
	local KV_int=$(( KV_MAJOR * 65536 + KV_MINOR * 256 + KV_MICRO ))

	# We make version 2.2.0 the minimum version we will handle as
	# a sanity check ... if its less, we fail ...
	if [[ ${KV_int} -ge 131584 ]] ; then
		echo "${KV_int}"
		return 0
	fi
	return 1
}

g_int_to_KV() {
	local version=$1 major minor micro
	major=$((version / 65536))
	minor=$(((version % 65536) / 256))
	micro=$((version % 256))
	echo ${major}.${minor}.${micro}
}

eend_KV() {
	[[ $(g_KV_to_int $1) -ge $(g_KV_to_int $2) ]]
	eend $?
}

get_kheader_version() {
	printf '#include <linux/version.h>\nLINUX_VERSION_CODE\n' | \
	$(tc-getCPP ${CTARGET}) -I "$(build_eprefix)$(alt_build_headers)" - | \
	tail -n 1
}

# We collect all sanity checks here. Consistency is not guranteed between
# pkg_ and src_ phases, so we call this function both in pkg_pretend and in
# src_unpack.
sanity_prechecks() {
	# CrOS makes sure these checks all pass.
	return

	# Prevent native builds from downgrading
	if [[ ${MERGE_TYPE} != "buildonly" ]] && \
		[[ -z ${ROOT} ]] && \
		[[ ${CBUILD} == ${CHOST} ]] && \
		[[ ${CHOST} == ${CTARGET} ]] ; then

		# The high rev # is to allow people to downgrade between -r#
		# versions. We want to block 2.20->2.19, but 2.20-r3->2.20-r2
		# should be fine. Hopefully we never actually use a r# this
		# high.
		if has_version ">${CATEGORY}/${P}-r10000" ; then
			eerror "Sanity check to keep you from breaking your system:"
			eerror " Downgrading glibc is not supported and a sure way to destruction."
			[[ ${I_ALLOW_TO_BREAK_MY_SYSTEM} = yes ]] || die "Aborting to save your system."
		fi

		if ! do_run_test '#include <unistd.h>\n#include <sys/syscall.h>\nint main(){return syscall(1000)!=-1;}\n' ; then
			eerror "Your old kernel is broken. You need to update it to a newer"
			eerror "version as syscall(<bignum>) will break. See bug 279260."
			die "Old and broken kernel."
		fi
	fi

	# Users have had a chance to phase themselves, time to give em the boot
	if [[ -e ${EROOT}/etc/locale.gen ]] && [[ -e ${EROOT}/etc/locales.build ]] ; then
		eerror "You still haven't deleted ${EROOT}/etc/locales.build."
		eerror "Do so now after making sure ${EROOT}/etc/locale.gen is kosher."
		die "Lazy upgrader detected"
	fi

	if [[ ${CTARGET} == i386-* ]] ; then
		eerror "i386 CHOSTs are no longer supported."
		eerror "Chances are you don't actually want/need i386."
		eerror "Please read https://www.gentoo.org/doc/en/change-chost.xml"
		die "Please fix your CHOST"
	fi

	if [[ -e /proc/xen ]] && [[ $(tc-arch) == "x86" ]] && ! is-flag -mno-tls-direct-seg-refs ; then
		ewarn "You are using Xen but don't have -mno-tls-direct-seg-refs in your CFLAGS."
		ewarn "This will result in a 50% performance penalty when running with a 32bit"
		ewarn "hypervisor, which is probably not what you want."
	fi

	# Check for sanity of /etc/nsswitch.conf
	if [[ -e ${EROOT}/etc/nsswitch.conf ]] ; then
		local entry
		for entry in passwd group shadow; do
			if ! egrep -q "^[ \t]*${entry}:.*files" "${EROOT}"/etc/nsswitch.conf; then
				eerror "Your ${EROOT}/etc/nsswitch.conf is out of date."
				eerror "Please make sure you have 'files' entries for"
				eerror "'passwd:', 'group:' and 'shadow:' databases."
				eerror "For more details see:"
				eerror "  https://wiki.gentoo.org/wiki/Project:Toolchain/nsswitch.conf_in_glibc-2.26"
				die "nsswitch.conf has no 'files' provider in '${entry}'."
			fi
		done
	fi

	# ABI-specific checks follow here. Hey, we have a lot more specific conditions that
	# we test for...
	if ! is_crosscompile ; then
		if use amd64 && use multilib && [[ ${MERGE_TYPE} != "binary" ]] ; then
			ebegin "Checking that IA32 emulation is enabled in the running kernel"
			echo 'int main(){return 0;}' > "${T}/check-ia32-emulation.c"
			local STAT
			if "${CC-${CHOST}-gcc}" ${CFLAGS_x86} "${T}/check-ia32-emulation.c" -o "${T}/check-ia32-emulation.elf32"; then
				"${T}/check-ia32-emulation.elf32"
				STAT=$?
			else
				# Don't fail here to allow single->multi ABI switch
				# or recover from breakage like bug #646424
				ewarn "Failed to compile the ABI test. Broken host glibc?"
				STAT=0
			fi
			rm -f "${T}/check-ia32-emulation.elf32"
			eend $STAT
			[[ $STAT -eq 0 ]] || die "CONFIG_IA32_EMULATION must be enabled in the kernel to compile a multilib glibc."
		fi

	fi

	# When we actually have to compile something...
	if ! just_headers ; then
		ebegin "Checking gcc for __thread support"
		if ! eend $(want__thread ; echo $?) ; then
			echo
			eerror "Could not find a gcc that supports the __thread directive!"
			eerror "Please update your binutils/gcc and try again."
			die "No __thread support in gcc!"
		fi

		if [[ ${CTARGET} == *-linux* ]] ; then
			local run_kv build_kv want_kv

			run_kv=$(g_get_running_KV)
			build_kv=$(g_int_to_KV $(get_kheader_version))
			want_kv=${MIN_KERN_VER}

			if ! is_crosscompile && ! tc-is-cross-compiler ; then
				# Building fails on an non-supporting kernel
				ebegin "Checking running kernel version (${run_kv} >= ${want_kv})"
				if ! eend_KV ${run_kv} ${want_kv} ; then
					echo
					eerror "You need a kernel of at least ${want_kv}!"
					die "Kernel version too low!"
				fi
			fi

			ebegin "Checking linux-headers version (${build_kv} >= ${want_kv})"
			if ! eend_KV ${build_kv} ${want_kv} ; then
				echo
				eerror "You need linux-headers of at least ${want_kv}!"
				die "linux-headers version too low!"
			fi
		fi
	fi
}

#
# the phases
#

# pkg_pretend

# CrOS doesn't care about these checks.
disabled_pkg_pretend() {
	# All the checks...
	einfo "Checking general environment sanity."
	sanity_prechecks
}

pkg_setup() {
	# see bug 682570
	[[ -z ${BOOTSTRAP_RAP} ]] && python-any-r1_pkg_setup
}

# src_unpack

src_unpack() {
	# Consistency is not guaranteed between pkg_ and src_ ...
	sanity_prechecks

	use multilib-bootstrap && unpack gcc-multilib-bootstrap-${GCC_BOOTSTRAP_VER}.tar.xz

	setup_env

	if [[ ${PV} == 9999* ]] ; then
		EGIT_REPO_URI="https://anongit.gentoo.org/git/proj/toolchain/glibc-patches.git"
		EGIT_CHECKOUT_DIR=${WORKDIR}/patches-git
		git-r3_src_unpack
		mv patches-git/9999 patches || die

		EGIT_REPO_URI="https://sourceware.org/git/glibc.git"
		EGIT_CHECKOUT_DIR=${S}
		git-r3_src_unpack
	else
		unpack ${P}.tar.xz

		cd "${WORKDIR}" || die
		unpack glibc-${RELEASE_VER}-patches-${PATCH_VER}.tar.xz
	fi

	cd "${WORKDIR}" || die
	unpack locale-gen-${LOCALE_GEN_VER}.tar.gz
}

src_prepare() {
	local patchsetname
	if ! use vanilla ; then
		if [[ ${PV} == 9999* ]] ; then
			patchsetname="from git master"
		else
			patchsetname="${RELEASE_VER}-${PATCH_VER}"
		fi
		einfo "Applying Gentoo Glibc Patchset ${RELEASE_VER}"
		EPATCH_SUFFIX="patch" EPATCH_FORCE="yes" eapply "${WORKDIR}"/patches
		einfo "Done."
	fi
	EPATCH_SUFFIX="patch" EPATCH_FORCE="yes" eapply "${FILESDIR}"/local/${PN}-${PV}

	default

	gnuconfig_update

	cd "${WORKDIR}"
	find . -name configure -exec touch {} +

	# move the external locale-gen to its old place
	mkdir extra || die
	mv locale-gen-${LOCALE_GEN_VER} extra/locale || die
	EPATCH_FORCE="yes" eapply "${FILESDIR}"/glibc-locale-gen-omit-spam-when-in-quiet-mode.patch
	EPATCH_FORCE="yes" eapply "${FILESDIR}"/glibc-locale-gen-omit-more-spam-when-in-quiet-mode.patch
	EPATCH_FORCE="yes" eapply "${FILESDIR}"/glibc-locale-gen-skip-duplicate-locales-when-normalized.patch

	eprefixify extra/locale/locale-gen

	# Fix permissions on some of the scripts.
	chmod u+x "${S}"/scripts/*.sh

	cd "${S}"
}

glibc_do_configure() {
	# Glibc does not work with gold (for various reasons) #269274.
	tc-ld-disable-gold

	# CXX isnt handled by the multilib system, so if we dont unset here
	# we accumulate crap across abis
	unset CXX

	einfo "Configuring glibc for nptl"

	if use doc ; then
		export MAKEINFO=makeinfo
	else
		export MAKEINFO=/dev/null
	fi

	local v
	for v in ABI CBUILD CHOST CTARGET CBUILD_OPT CTARGET_OPT CC CXX LD {AS,C,CPP,CXX,LD}FLAGS MAKEINFO NM READELF; do
		einfo " $(printf '%15s' ${v}:)   ${!v}"
	done

	# CFLAGS can contain ABI-specific flags like -mfpu=neon, see bug #657760
	# To build .S (assembly) files with the same ABI-specific flags
	# upstream currently recommends adding CFLAGS to CC/CXX:
	#    https://sourceware.org/PR23273
	# Note: Passing CFLAGS via CPPFLAGS overrides glibc's arch-specific CFLAGS
	# and breaks multiarch support. See 659030#c3 for an example.
	# The glibc configure script doesn't properly use LDFLAGS all the time.
	export CC="$(tc-getCC ${CTARGET})"
	export CXX="$(tc-getCXX ${CTARGET})"
	cros_use_gcc
	export CC="${CC} ${CFLAGS} ${LDFLAGS}"
	export CXX="${CXX} $(get_abi_CFLAGS) ${CFLAGS}"
	einfo " $(printf '%15s' 'Manual CC:')   ${CC}"

	if is_crosscompile; then
		# Assume worst-case bootstrap: glibc is buil first time
		# when ${CTARGET}-g++ is not available yet. We avoid
		# building auxiliary programs that require C++: bug #683074
		# It should not affect final result.
		export libc_cv_cxx_link_ok=no
	fi
	einfo " $(printf '%15s' 'Manual CXX:')   ${CXX}"

	# Always use tuple-prefixed toolchain. For non-native ABI glibc's configure
	# can't detect them automatically due to ${CHOST} mismatch and fallbacks
	# to unprefixed tools. Similar to multilib.eclass:multilib_toolchain_setup().
	export NM="$(tc-getNM ${CTARGET})"
	export READELF="$(tc-getREADELF ${CTARGET})"
	einfo " $(printf '%15s' 'Manual NM:')   ${NM}"
	einfo " $(printf '%15s' 'Manual READELF:')   ${READELF}"

	echo

	local myconf=()

	case ${CTARGET} in
		m68k*)
			# setjmp() is not compatible with stack protection:
			# https://sourceware.org/PR24202
			myconf+=( --enable-stack-protector=no )
			;;
		*)
			# Use '=strong' instead of '=all' to protect only functions
			# worth protecting from stack smashes.
			# '=all' is also known to have a problem in IFUNC resolution
			# tests: https://sourceware.org/PR25680, bug #712356.
			myconf+=( --enable-stack-protector=strong )
			;;
	esac
	myconf+=( --enable-stackguard-randomization )

	# Keep an allowlist of targets supporing IFUNC. glibc's ./configure
	# is not robust enough to detect proper support:
	#    https://bugs.gentoo.org/641216
	#    https://sourceware.org/PR22634#c0
	case $(tc-arch ${CTARGET}) in
		# Keep an allowlist of targets where autodetection mostly works.
		amd64|x86|sparc|ppc|ppc64|arm|arm64|s390) ;;
		# Denylist everywhere else
		*) myconf+=( libc_cv_ld_gnu_indirect_function=no ) ;;
	esac

	# Enable Intel Control-flow Enforcement Technology on amd64 if requested
	case ${CTARGET} in
		x86_64-*) myconf+=( $(use_enable cet) ) ;;
		*) ;;
	esac

	[[ $(tc-is-softfloat) == "yes" ]] && myconf+=( --without-fp )

	myconf+=( --enable-kernel=${MIN_KERN_VER} )

	# Since SELinux support is only required for nscd, only enable it if:
	# 1. USE selinux
	# 2. only for the primary ABI on multilib systems
	# 3. Not a crosscompile
	if ! is_crosscompile && use selinux ; then
		if use multilib ; then
			if is_final_abi ; then
				myconf+=( --with-selinux )
			else
				myconf+=( --without-selinux )
			fi
		else
			myconf+=( --with-selinux )
		fi
	else
		myconf+=( --without-selinux )
	fi

	# Force a few tests where we always know the answer but
	# configure is incapable of finding it.
	if is_crosscompile ; then
		export \
			libc_cv_c_cleanup=yes \
			libc_cv_forced_unwind=yes
	fi

	myconf+=(
		--without-cvs
		--disable-werror
		--enable-bind-now
		--build=${CBUILD_OPT:-${CBUILD}}
		--host=${CTARGET_OPT:-${CTARGET}}
		$(use_enable profile)
		$(use_with gd)
		--with-headers=$(build_eprefix)$(alt_build_headers)
		--prefix="$(host_eprefix)/usr"
		--sysconfdir="$(host_eprefix)/etc"
		--localstatedir="$(host_eprefix)/var"
		--libdir='$(prefix)'/$(get_libdir)
		--mandir='$(prefix)'/share/man
		--infodir='$(prefix)'/share/info
		--libexecdir='$(libdir)'/misc/glibc
		--with-bugurl=https://bugs.gentoo.org/
		--with-pkgversion="$(glibc_banner)"
		--enable-crypt
		$(use_multiarch || echo --disable-multi-arch)
		$(use_enable static-pie)
		$(use_enable systemtap)
		$(use_enable nscd)

		# locale data is arch-independent
		# https://bugs.gentoo.org/753740
		libc_cv_complocaledir='${exec_prefix}/lib/locale'

		# -march= option tricks build system to infer too
		# high ISA level: https://sourceware.org/PR27318
		libc_cv_include_x86_isa_level=no

		${EXTRA_ECONF}
	)

	# We rely on sys-libs/timezone-data for timezone tools normally.
	myconf+=( $(use_enable vanilla timezone-tools) )

	# These libs don't have configure flags.
	ac_cv_lib_audit_audit_log_user_avc_message=$(usex audit || echo no)
	ac_cv_lib_cap_cap_init=$(usex caps || echo no)

	# There is no configure option for this and we need to export it
	# since the glibc build will re-run configure on itself
	export libc_cv_rootsbindir="$(host_eprefix)/sbin"
	export libc_cv_slibdir="$(host_eprefix)/$(get_libdir)"

	# We take care of patching our binutils to use both hash styles,
	# and many people like to force gnu hash style only, so disable
	# this overriding check.  #347761
	export libc_cv_hashstyle=no

	local builddir=$(builddir nptl)
	mkdir -p "${builddir}"
	cd "${builddir}"
	set -- "${S}"/configure "${myconf[@]}"
	echo "$@"
	"$@" || die "failed to configure glibc"

	# ia64 static cross-compilers are a pita in so much that they
	# can't produce static ELFs (as the libgcc.a is broken).  so
	# disable building of the programs for those targets if it
	# doesn't work.
	# XXX: We could turn this into a compiler test, but ia64 is
	# the only one that matters, so this should be fine for now.
	if is_crosscompile && [[ ${CTARGET} == ia64* ]] ; then
		sed -i '1i+link-static = touch $@' config.make
	fi

	# If we're trying to migrate between ABI sets, we need
	# to lie and use a local copy of gcc.  Like if the system
	# is built with MULTILIB_ABIS="amd64 x86" but we want to
	# add x32 to it, gcc/glibc don't yet support x32.
	#
	if [[ -n ${GCC_BOOTSTRAP_VER} ]] && use multilib-bootstrap ; then
		echo 'main(){}' > "${T}"/test.c
		if ! $(tc-getCC ${CTARGET}) ${CFLAGS} ${LDFLAGS} "${T}"/test.c -Wl,-emain -lgcc 2>/dev/null ; then
			sed -i -e '/^CC = /s:$: -B$(objdir)/../'"gcc-multilib-bootstrap-${GCC_BOOTSTRAP_VER}/${ABI}:" config.make || die
		fi
	fi
}

glibc_headers_configure() {
	export ABI=default

	cros_use_gcc

	local builddir=$(builddir "headers")
	mkdir -p "${builddir}"
	cd "${builddir}"

	# if we don't have a compiler yet, we can't really test it now ...
	# hopefully they don't affect header generation, so let's hope for
	# the best here ...
	local v vars=(
		ac_cv_header_cpuid_h=yes
		libc_cv_{386,390,alpha,arm,hppa,ia64,mips,{powerpc,sparc}{,32,64},sh,x86_64}_tls=yes
		libc_cv_asm_cfi_directives=yes
		libc_cv_broken_visibility_attribute=no
		libc_cv_c_cleanup=yes
		libc_cv_compiler_powerpc64le_binary128_ok=yes
		libc_cv_forced_unwind=yes
		libc_cv_gcc___thread=yes
		libc_cv_mlong_double_128=yes
		libc_cv_mlong_double_128ibm=yes
		libc_cv_ppc_machine=yes
		libc_cv_ppc_rel16=yes
		libc_cv_predef_fortify_source=no
		libc_cv_target_power8_ok=yes
		libc_cv_visibility_attribute=yes
		libc_cv_z_combreloc=yes
		libc_cv_z_execstack=yes
		libc_cv_z_initfirst=yes
		libc_cv_z_nodelete=yes
		libc_cv_z_nodlopen=yes
		libc_cv_z_relro=yes
		libc_mips_abi=${ABI}
		libc_mips_float=$([[ $(tc-is-softfloat) == "yes" ]] && echo soft || echo hard)
		# These libs don't have configure flags.
		ac_cv_lib_audit_audit_log_user_avc_message=no
		ac_cv_lib_cap_cap_init=no
	)

	einfo "Forcing cached settings:"
	for v in "${vars[@]}" ; do
		einfo " ${v}"
		export ${v}
	done

	local headers_only_arch_CPPFLAGS=()

	# Blow away some random CC settings that screw things up. #550192
	if [[ -d ${S}/sysdeps/mips ]]; then
		pushd "${S}"/sysdeps/mips >/dev/null
		sed -i -e '/^CC +=/s:=.*:= -D_MIPS_SZPTR=32:' mips32/Makefile mips64/n32/Makefile || die
		sed -i -e '/^CC +=/s:=.*:= -D_MIPS_SZPTR=64:' mips64/n64/Makefile || die

		# Force the mips ABI to the default.  This is OK because the set of
		# installed headers in this phase is the same between the 3 ABIs.
		# If this ever changes, this hack will break, but that's unlikely
		# as glibc discourages that behavior.
		# https://crbug.com/647033
		sed -i -e 's:abiflag=.*:abiflag=_ABIO32:' preconfigure || die

		popd >/dev/null
	fi

	case ${CTARGET} in
	riscv*)
		# RISC-V interrogates the compiler to determine which target to
		# build.  If building the headers then we don't strictly need a
		# RISC-V compiler, so the built-in definitions that are provided
		# along with all RISC-V compiler might not exist.  This causes
		# glibc's RISC-V preconfigure script to blow up.  Since we're just
		# building the headers any value will actually work here, so just
		# pick the standard one (rv64g/lp64d) to make the build scripts
		# happy for now -- the headers are all the same anyway so it
		# doesn't matter.
		headers_only_arch_CPPFLAGS+=(
			-D__riscv_xlen=64
			-D__riscv_flen=64
			-D__riscv_float_abi_double=1
			-D__riscv_atomic=1
		) ;;
	esac

	local myconf=()
	myconf+=(
		--disable-sanity-checks
		--enable-hacker-mode
		--without-cvs
		--disable-werror
		--enable-bind-now
		--build=${CBUILD_OPT:-${CBUILD}}
		--host=${CTARGET_OPT:-${CTARGET}}
		--with-headers=$(build_eprefix)$(alt_build_headers)
		--prefix="$(host_eprefix)/usr"
		${EXTRA_ECONF}
	)

	# Nothing is compiled here which would affect the headers for the target.
	# So forcing CC/CFLAGS is sane.
	local headers_only_CC=$(tc-getBUILD_CC)
	local headers_only_CFLAGS="-O1 -pipe"
	local headers_only_CPPFLAGS="-U_FORTIFY_SOURCE ${headers_only_arch_CPPFLAGS[*]}"
	local headers_only_LDFLAGS=""
	set -- "${S}"/configure "${myconf[@]}"
	echo \
		"CC=${headers_only_CC}" \
		"CFLAGS=${headers_only_CFLAGS}" \
		"CPPFLAGS=${headers_only_CPPFLAGS}" \
		"LDFLAGS=${headers_only_LDFLAGS}" \
		"$@"
	CC=${headers_only_CC} \
	CFLAGS=${headers_only_CFLAGS} \
	CPPFLAGS=${headers_only_CPPFLAGS} \
	LDFLAGS="" \
	"$@" || die "failed to configure glibc"
}

do_src_configure() {
	if just_headers ; then
		glibc_headers_configure
	else
		glibc_do_configure nptl
	fi
}

src_configure() {
	EXTRA_ECONF+=" --with-bugurl=http://crbug.com/new"
	foreach_abi do_src_configure
}

do_src_compile() {
	emake -C "$(builddir nptl)"
}

src_compile() {
	if just_headers ; then
		return
	fi

	foreach_abi do_src_compile
}

glibc_src_test() {
	cd "$(builddir nptl)"

	local myxfailparams=""
	if [[ "${GENTOO_GLIBC_XFAIL_TESTS}" == "yes" ]] ; then
		for myt in ${XFAIL_TEST_LIST[@]} ; do
			myxfailparams+="test-xfail-${myt}=yes "
		done
	fi

	# sandbox does not understand unshare() and prevents
	# writes to /proc/, which makes many tests fail

	SANDBOX_ON=0 LD_PRELOAD= emake ${myxfailparams} check
}

do_src_test() {
	local ret=0

	glibc_src_test
	: $(( ret |= $? ))

	return ${ret}
}

src_test() {
	if just_headers ; then
		return
	fi

	# Give tests more time to complete.
	export TIMEOUTFACTOR=5

	foreach_abi do_src_test || die "tests failed"
}

run_locale_gen() {
	# if the host locales.gen contains no entries, we'll install everything
	local root="$1"
	local inplace=""

	if [[ "${root}" == "--inplace-glibc" ]] ; then
		inplace="--inplace-glibc"
		root="$2"
	fi

	local locale_list="${root}/etc/locale.gen"

	pushd "${ED}"/$(get_libdir) >/dev/null

	if [[ -z $(locale-gen --list --config "${locale_list}") ]] ; then
		[[ -z ${inplace} ]] && ewarn "Generating all locales; edit /etc/locale.gen to save time/space"
		locale_list="${root}/usr/share/i18n/SUPPORTED"
	fi

	set -- locale-gen ${inplace} --jobs $(makeopts_jobs) --config "${locale_list}" \
		--destdir "${root}"
	echo "$@"
	"$@"

	popd >/dev/null
}

glibc_do_src_install() {
	local builddir=$(builddir nptl)
	cd "${builddir}"

	emake install_root="${D}/$(build_eprefix)$(alt_prefix)" install

	# This version (2.26) provides some compatibility libraries for the NIS/NIS+ support
	# which come without headers etc. Only needed for binary packages since the
	# external net-libs/libnsl has increased soversion. Keep only versioned libraries.
	find "${D}" -name "libnsl.a" -delete
	find "${D}" -name "libnsl.so" -delete

	# Normally upstream_pv is ${PV}. Live ebuilds are exception, there we need
	# to infer upstream version:
	# '#define VERSION "2.26.90"' -> '2.26.90'
	local upstream_pv=$(sed -n -r 's/#define VERSION "(.*)"/\1/p' "${S}"/version.h)

	# gdb thread introspection relies on local libpthreas symbols. stripping breaks it
	# See Note [Disable automatic stripping]
	dostrip -x $(alt_libdir)/libpthread-${upstream_pv}.so

	if [[ -e ${ED}/$(alt_usrlibdir)/libm-${upstream_pv}.a ]] ; then
		# Move versioned .a file out of libdir to evade portage QA checks
		# instead of using gen_usr_ldscript(). We fix ldscript as:
		# "GROUP ( /usr/lib64/libm-<pv>.a ..." -> "GROUP ( /usr/lib64/glibc-<pv>/libm-<pv>.a ..."
		sed -i "s@\(libm-${upstream_pv}.a\)@${P}/\1@" "${ED}"/$(alt_usrlibdir)/libm.a || die
		dodir $(alt_usrlibdir)/${P}
		mv "${ED}"/$(alt_usrlibdir)/libm-${upstream_pv}.a "${ED}"/$(alt_usrlibdir)/${P}/libm-${upstream_pv}.a || die
	fi

	if is_crosscompile ; then
		# punt all the junk not needed by a cross-compiler
		cd "${D}"/usr/${CTARGET} || die
		rm -rf ./{,usr/}{etc,share} ./{,usr/}*/misc

		# Remove all executables except getent, ldd, and ldconfig.
		# See http://crosbug.com/1570
		find ./usr/bin -name getent -o -name ldd -o -type f -exec rm {} ';'
		find ./sbin -name ldconfig -o -type f -exec rm {} ';'
		rm -rf ./usr/sbin
	fi

	# We'll take care of the cache ourselves
	rm -f "${ED}"/etc/ld.so.cache

	# Everything past this point just needs to be done once ...
	is_final_abi || return 0

	# Make sure the non-native interp can be found on multilib systems even
	# if the main library set isn't installed into the right place.  Maybe
	# we should query the active gcc for info instead of hardcoding it ?
	local i ldso_abi ldso_name
	local ldso_abi_list=(
		# x86
		amd64   /lib64/ld-linux-x86-64.so.2
		x32     /libx32/ld-linux-x32.so.2
		x86     /lib/ld-linux.so.2
		# mips
		o32     /lib/ld.so.1
		n32     /lib32/ld.so.1
		n64     /lib64/ld.so.1
		# powerpc
		ppc     /lib/ld.so.1
		ppc64   /lib64/ld64.so.1
		# riscv
		ilp32d  /lib/ld-linux-riscv32-ilp32d.so.1
		ilp32   /lib/ld-linux-riscv32-ilp32.so.1
		lp64d   /lib/ld-linux-riscv64-lp64d.so.1
		lp64    /lib/ld-linux-riscv64-lp64.so.1
		# s390
		s390    /lib/ld.so.1
		s390x   /lib/ld64.so.1
		# sparc
		sparc32 /lib/ld-linux.so.2
		sparc64 /lib64/ld-linux.so.2
	)
	case $(tc-endian) in
	little)
		ldso_abi_list+=(
			# arm
			arm64   /lib/ld-linux-aarch64.so.1
		)
		;;
	big)
		ldso_abi_list+=(
			# arm
			arm64   /lib/ld-linux-aarch64_be.so.1
		)
		;;
	esac
	if [[ ${SYMLINK_LIB} == "yes" ]] && [[ ! -e ${ED}/$(alt_prefix)/lib ]] ; then
		dosym $(get_abi_LIBDIR ${DEFAULT_ABI}) $(alt_prefix)/lib
	fi
	for (( i = 0; i < ${#ldso_abi_list[@]}; i += 2 )) ; do
		ldso_abi=${ldso_abi_list[i]}
		has ${ldso_abi} $(get_install_abis) || continue

		ldso_name="$(alt_prefix)${ldso_abi_list[i+1]}"
		if [[ ! -L ${ED}/${ldso_name} && ! -e ${ED}/${ldso_name} ]] ; then
			dosym ../$(get_abi_LIBDIR ${ldso_abi})/${ldso_name##*/} ${ldso_name}
		fi
	done

	# With devpts under Linux mounted properly, we do not need the pt_chown
	# binary to be setuid.  This is because the default owners/perms will be
	# exactly what we want.
	if ! use suid ; then
		find "${ED}" -name pt_chown -exec chmod -s {} +
	fi

	#################################################################
	# EVERYTHING AFTER THIS POINT IS FOR NATIVE GLIBC INSTALLS ONLY #
	# Make sure we install some symlink hacks so that when we build
	# a 2nd stage cross-compiler, gcc finds the target system
	# headers correctly.  See gcc/doc/gccinstall.info
	if is_crosscompile ; then
		# We need to make sure that /lib and /usr/lib always exists.
		# gcc likes to use relative paths to get to its multilibs like
		# /usr/lib/../lib64/.  So while we don't install any files into
		# /usr/lib/, we do need it to exist.
		cd "${ED}"$(alt_libdir)/..
		[[ -e lib ]] || mkdir lib
		cd "${ED}"$(alt_usrlibdir)/..
		[[ -e lib ]] || mkdir lib

		cd "${ED}"${alt_libdir} || die
		rm -rf ./{,usr/}{etc,share} ./{,usr/}*/misc

		# Remove all executables except getent, ldd, and ldconfig.
		# See http://crosbug.com/1570
		find ./usr/bin -name getent -o -name ldd -o -type f -exec rm {} ';'
		find ./sbin -name ldconfig -o -type f -exec rm {} ';'
		rm -rf ./usr/sbin

		dosym usr/include $(alt_prefix)/sys-include
		return 0
	fi

	# Files for Debian-style locale updating
	dodir /usr/share/i18n
	sed \
		-e "/^#/d" \
		-e "/SUPPORTED-LOCALES=/d" \
		-e "s: \\\\::g" -e "s:/: :g" \
		"${S}"/localedata/SUPPORTED > "${ED}"/usr/share/i18n/SUPPORTED \
		|| die "generating /usr/share/i18n/SUPPORTED failed"
	cd "${WORKDIR}"/extra/locale
	dosbin locale-gen
	doman *.[0-8]
	insinto /etc
	doins locale.gen

	keepdir /usr/lib/locale

	cd "${S}"

	# Install misc network config files
	insinto /etc
	doins posix/gai.conf nss/nsswitch.conf

	# Gentoo-specific
	newins "${FILESDIR}"/host.conf-1 host.conf

	if use nscd ; then
		doins nscd/nscd.conf

		newinitd "$(prefixify_ro "${FILESDIR}"/nscd-1)" nscd

		local nscd_args=(
			-e "s:@PIDFILE@:$(strings "${ED}"/usr/sbin/nscd | grep nscd.pid):"
		)

		sed -i "${nscd_args[@]}" "${ED}"/etc/init.d/nscd

		systemd_dounit nscd/nscd.service
		systemd_newtmpfilesd nscd/nscd.tmpfiles nscd.conf
	fi

	echo 'LDPATH="include ld.so.conf.d/*.conf"' > "${T}"/00glibc
	doenvd "${T}"/00glibc

	for d in BUGS ChangeLog CONFORMANCE FAQ NEWS NOTES PROJECTS README* ; do
		[[ -s ${d} ]] && dodoc ${d}
	done
	dodoc -r ChangeLog.old

	# Prevent overwriting of the /etc/localtime symlink.  We'll handle the
	# creation of the "factory" symlink in pkg_postinst().
	rm -f "${ED}"/etc/localtime

	# Generate all locales if this is a native build as locale generation
	if use compile-locales && ! is_crosscompile ; then
		run_locale_gen --inplace-glibc "${ED}/"
		sed -e 's:COMPILED_LOCALES="":COMPILED_LOCALES="1":' -i "${ED}"/usr/sbin/locale-gen || die
	fi
}

glibc_headers_install() {
	local builddir=$(builddir "headers")
	cd "${builddir}"
	emake install_root="${D}/$(build_eprefix)$(alt_prefix)" install-headers

	insinto $(alt_headers)/gnu
	doins "${S}"/include/gnu/stubs.h

	# Make sure we install the sys-include symlink so that when
	# we build a 2nd stage cross-compiler, gcc finds the target
	# system headers correctly.  See gcc/doc/gccinstall.info
	dosym usr/include $(alt_prefix)/sys-include
}

src_install() {
	if just_headers ; then
		export ABI=default
		glibc_headers_install
		return
	fi

	foreach_abi glibc_do_src_install

	if ! use static-libs ; then
		einfo "Not installing static glibc libraries"
		find "${ED}" -name "*.a" -and -not -name "*_nonshared.a" -delete
	fi
}

# Simple test to make sure our new glibc isn't completely broken.
# Make sure we don't test with statically built binaries since
# they will fail.  Also, skip if this glibc is a cross compiler.
#
# If coreutils is built with USE=multicall, some of these files
# will just be wrapper scripts, not actual ELFs we can test.
glibc_sanity_check() {
	cd / #228809

	# We enter ${ED} so to avoid trouble if the path contains
	# special characters; for instance if the path contains the
	# colon character (:), then the linker will try to split it
	# and look for the libraries in an unexpected place. This can
	# lead to unsafe code execution if the generated prefix is
	# within a world-writable directory.
	# (e.g. /var/tmp/portage:${HOSTNAME})
	pushd "${ED}"/$(get_libdir) >/dev/null

	local x striptest
	for x in cal date env free ls true uname uptime ; do
		x=$(type -p ${x})
		[[ -z ${x} || ${x} != ${EPREFIX}/* ]] && continue
		striptest=$(LC_ALL="C" file -L ${x} 2>/dev/null) || continue
		case ${striptest} in
		*"statically linked"*) continue;;
		*"ASCII text"*) continue;;
		esac
		# We need to clear the locale settings as the upgrade might want
		# incompatible locale data.  This test is not for verifying that.
		LC_ALL=C \
		./ld-*.so --library-path . ${x} > /dev/null \
			|| die "simple run test (${x}) failed"
	done

	popd >/dev/null
}

pkg_preinst() {
	# nothing to do if just installing headers
	just_headers && return

	# prepare /etc/ld.so.conf.d/ for files
	mkdir -p "${EROOT}"/etc/ld.so.conf.d

	# Default /etc/hosts.conf:multi to on for systems with small dbs.
	if [[ $(wc -l < "${EROOT}"/etc/hosts) -lt 1000 ]] ; then
		sed -i '/^multi off/s:off:on:' "${ED}"/etc/host.conf
		einfo "Defaulting /etc/host.conf:multi to on"
	fi

	[[ -n ${ROOT} ]] && return 0
	[[ -d ${ED}/$(get_libdir) ]] || return 0
	[[ -z ${BOOTSTRAP_RAP} ]] && glibc_sanity_check

	if [[ -L ${EROOT}/usr/lib/locale ]]; then
		# Help portage migrate this to a directory
		# https://bugs.gentoo.org/753740
		rm "${EROOT}"/usr/lib/locale || die
	fi
}

pkg_postinst() {
	# nothing to do if just installing headers
	just_headers && return

	if ! tc-is-cross-compiler && [[ -x ${EROOT}/usr/sbin/iconvconfig ]] ; then
		# Generate fastloading iconv module configuration file.
		"${EROOT}"/usr/sbin/iconvconfig --prefix="${ROOT}/"
	fi

	if ! is_crosscompile && [[ -z ${ROOT} ]] ; then
		use compile-locales || run_locale_gen "${EROOT}/"
	fi

	# Check for sanity of /etc/nsswitch.conf, take 2
	if [[ -e ${EROOT}/etc/nsswitch.conf ]] && ! has_version sys-auth/libnss-nis ; then
		local entry
		for entry in passwd group shadow; do
			if egrep -q "^[ \t]*${entry}:.*nis" "${EROOT}"/etc/nsswitch.conf; then
				ewarn ""
				ewarn "Your ${EROOT}/etc/nsswitch.conf uses NIS. Support for that has been"
				ewarn "removed from glibc and is now provided by the package"
				ewarn "  sys-auth/libnss-nis"
				ewarn "Install it now to keep your NIS setup working."
				ewarn ""
			fi
		done
	fi
}
