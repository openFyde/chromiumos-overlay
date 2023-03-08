# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6..9} )
inherit flag-o-matic python-single-r1 toolchain-funcs

export CTARGET=${CTARGET:-${CHOST}}

if [[ ${CTARGET} == ${CHOST} ]] ; then
	if [[ ${CATEGORY} == cross-* ]] ; then
		export CTARGET=${CATEGORY#cross-}
	fi
fi

is_cross() { [[ ${CHOST} != ${CTARGET} ]] ; }

case ${PV} in
	9999*)
		# live git tree
		EGIT_REPO_URI="https://sourceware.org/git/binutils-gdb.git"
		inherit git-r3
		SRC_URI=""
		;;
	*.*.50.2???????)
		# weekly snapshots
		SRC_URI="ftp://sourceware.org/pub/gdb/snapshots/current/gdb-weekly-${PV}.tar.xz"
		;;
	*)
		# Normal upstream release
		SRC_URI="mirror://gnu/gdb/${P}.tar.xz
			ftp://sourceware.org/pub/gdb/releases/${P}.tar.xz"
		;;
esac

PATCH_VER=""
PATCH_DEV=""
DESCRIPTION="GNU debugger"
HOMEPAGE="https://sourceware.org/gdb/"
SRC_URI="${SRC_URI}
	${PATCH_DEV:+https://dev.gentoo.org/~${PATCH_DEV}/distfiles/${P}-patches-${PATCH_VER}.tar.xz}
	${PATCH_VER:+mirror://gentoo/${P}-patches-${PATCH_VER}.tar.xz}
"

LICENSE="GPL-3+ LGPL-2.1+"
SLOT="0"

if [[ ${PV} != 9999* ]] ; then
	KEYWORDS="*"
fi

IUSE="amd64 cet guile lzma multitarget nls +python +server source-highlight test vanilla xml xxhash"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

# In fact, gdb's test suite needs some work to get passing.
# See e.g. https://sourceware.org/gdb/wiki/TestingGDB.
# As of 11.2, on amd64: "# of unexpected failures    8600"
# ia64 kernel crashes when gdb testsuite is running
# in fact, gdb's test suite needs some work to get passing.
# See e.g. https://sourceware.org/gdb/wiki/TestingGDB.
# As of 11.2, on amd64: "# of unexpected failures    8600"
RESTRICT="
	ia64? ( test )
	!test? ( test )
	test
"

RDEPEND="
	dev-libs/mpfr:0=
	dev-libs/gmp:=
	>=sys-libs/ncurses-5.2-r2
	>=sys-libs/readline-7:0=
	sys-libs/zlib
	lzma? ( app-arch/xz-utils )
	python? ( ${PYTHON_DEPS} )
	guile? ( >=dev-scheme/guile-2.0 )
	xml? ( dev-libs/expat )
	source-highlight? (
		dev-util/source-highlight
	)
	xxhash? (
		dev-libs/xxhash
	)
"
DEPEND="${RDEPEND}"
BDEPEND="
	app-arch/xz-utils
	sys-apps/texinfo
	virtual/yacc
	nls? ( sys-devel/gettext )
	source-highlight? ( virtual/pkgconfig )
	test? ( dev-util/dejagnu )
"

PATCHES=(
	"${FILESDIR}"/${PN}-8.3.1-verbose-build.patch
	"${FILESDIR}"/${P}-glibc-2.35-fsqrt.patch
	"${FILESDIR}"/${P}-python.patch
	"${FILESDIR}"/${P}-sigsys.patch
	"${FILESDIR}"/${P}-inlined-unwind.patch
	"${FILESDIR}"/${PN}-9.2-iterator-include.patch
)

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_prepare() {
	default

	# Avoid using ancient termcap from host on Prefix systems
	sed -i -e 's/termcap tinfow/tinfow/g' \
		gdb/configure{.ac,} || die
}

gdb_branding() {
	printf "Chromium OS ${PV} "

	if ! use vanilla && [[ -n ${PATCH_VER} ]] ; then
		printf "p${PATCH_VER}"
	else
		printf "vanilla"
	fi

	[[ -n ${EGIT_COMMIT} ]] && printf " ${EGIT_COMMIT}"
}

src_configure() {
	strip-unsupported-flags
	# We need to run gdb on both the host and devices, so compile for a
	# base set of x86-64 instructions.
	use amd64 && filter-flags "-march=*"

	# See https://www.gnu.org/software/make/manual/html_node/Parallel-Output.html
	# Avoid really confusing logs from subconfigure spam, makes logs far
	# more legible.
	MAKEOPTS="--output-sync=line ${MAKEOPTS}"

	local myconf=(
		# portage's econf() does not detect presence of --d-d-t
		# because it greps only top-level ./configure. But not
		# gnulib's or gdb's configure.
		--disable-dependency-tracking

		--with-pkgversion="$(gdb_branding)"
		--with-bugurl='http://crbug.com/new'
		--disable-werror
		# Disable modules that are in a combined binutils/gdb tree. bug #490566
		--disable-{binutils,etc,gas,gold,gprof,ld}

		# avoid automagic dependency on (currently prefix) systems
		# systems with debuginfod library, bug #754753
		--without-debuginfod

		$(use_enable test unit-tests)

		# Allow user to opt into CET for host libraries.
		# Ideally we would like automagic-or-disabled here.
		# But the check does not quite work on i686: bug #760926.
		$(use_enable cet)

		--with-libgmp-prefix=${ESYSROOT}/usr/$(get_libdir)
	)

	local sysroot="${EPREFIX}/usr/${CTARGET}"

	is_cross && myconf+=(
		--with-sysroot="${sysroot}"
		--includedir="${sysroot}/usr/include"
		--with-gdb-datadir="\${datadir}/gdb/${CTARGET}"
	)

	# gdbserver only works for native targets (CHOST==CTARGET).
	# it also doesn't support all targets, so rather than duplicate
	# the target list (which changes between versions), use the
	# "auto" value when things are turned on, which is triggered
	# whenever no --enable or --disable is given
	if is_cross || use !server ; then
		myconf+=( --disable-gdbserver )
	fi

	myconf+=(
		--enable-64-bit-bfd
		--disable-install-libbfd
		--disable-install-libiberty
		--enable-obsolete
		# This only disables building in the readline subdir.
		# For gdb itself, it'll use the system version.
		--disable-readline
		--with-system-readline
		# This only disables building in the zlib subdir.
		# For gdb itself, it'll use the system version.
		--without-zlib
		--with-system-zlib
		--with-separate-debug-dir="${EPREFIX}"/usr/lib/debug
		$(use_with xml expat)
		$(use_with lzma)
		$(use_enable nls)
		$(use_enable source-highlight)
		$(use multitarget && echo --enable-targets=all)
		$(use_with python python "${EPYTHON}")
		$(use_with xxhash)
		$(use_with guile)
	)

	if use sparc-solaris || use x86-solaris ; then
		# Disable largefile support
		# https://sourceware.org/ml/gdb-patches/2014-12/msg00058.html
		myconf+=( --disable-largefile )
	fi

	# source-highlight is detected with pkg-config: bug #716558
	export ac_cv_path_pkg_config_prog_path="$(tc-getPKG_CONFIG)"

	export CC_FOR_BUILD="$(tc-getBUILD_CC)"

	# ensure proper compiler is detected for Clang builds: bug #831202
	export GCC_FOR_TARGET="${CC_FOR_TARGET:-$(tc-getCC)}"

	econf "${myconf[@]}"
}

src_compile() {
	emake V=1
}

src_install() {
	emake V=1 DESTDIR="${D}" install

	find "${ED}"/usr -name libiberty.a -delete || die

	# Delete translations that conflict with binutils-libs. bug #528088
	# Note: Should figure out how to store these in an internal gdb dir.
	if use nls ; then
		find "${ED}" \
			-regextype posix-extended -regex '.*/(bfd|opcodes)[.]g?mo$' \
			-delete || die
	fi

	# Don't install docs when building a cross-gdb
	if [[ ${CTARGET} != ${CHOST} ]] ; then
		rm -rf "${ED}"/usr/share/{doc,info,locale} || die
		local f
		for f in "${ED}"/usr/share/man/*/* ; do
			if [[ ${f##*/} != ${CTARGET}-* ]] ; then
				mv "${f}" "${f%/*}/${CTARGET}-${f##*/}" || die
			fi
		done
		return 0
	fi

	# Install it by hand for now:
	# https://sourceware.org/ml/gdb-patches/2011-12/msg00915.html
	# Only install if it exists due to the twisted behavior (see
	# notes in src_configure above).
	[[ -e gdbserver/gdbreplay ]] && dobin gdbserver/gdbreplay

	docinto gdb
	dodoc gdb/CONTRIBUTE gdb/README gdb/MAINTAINERS \
		gdb/NEWS gdb/ChangeLog gdb/PROBLEMS
	docinto sim
	dodoc sim/{ChangeLog,MAINTAINERS,README-HACKING}

	if use server ; then
		docinto gdbserver
		dodoc gdbserver/{ChangeLog,README}
	fi

	if [[ -n ${PATCH_VER} ]] ; then
		dodoc "${WORKDIR}"/extra/gdbinit.sample
	fi

	# Remove shared info pages
	rm -f "${ED}"/usr/share/info/{annotate,bfd,configure,standards}.info*

	if use python ; then
		python_optimize "${ED}"/usr/share/gdb/python/gdb
	fi
}

pkg_postinst() {
	# Portage doesn't unmerge files in /etc
	rm -vf "${EROOT}"/etc/skel/.gdbinit

	if use prefix && [[ ${CHOST} == *-darwin* ]] ; then
		ewarn "gdb is unable to get a mach task port when installed by Prefix"
		ewarn "Portage, unprivileged.  To make gdb fully functional you'll"
		ewarn "have to perform the following steps:"
		ewarn "  % sudo chgrp procmod ${EPREFIX}/usr/bin/gdb"
		ewarn "  % sudo chmod g+s ${EPREFIX}/usr/bin/gdb"
	fi
}
