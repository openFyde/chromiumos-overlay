# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-devel/gcc/gcc-4.4.3-r3.ebuild,v 1.1 2010/06/19 01:53:09 zorry Exp $

EAPI=1

# (Crosstool-based) ChromeOS toolchain related variables.
COST_PKG_VERSION="${P}_cos_gg"

inherit eutils

GCC_FILESDIR="${PORTDIR}/sys-devel/gcc/files"

DESCRIPTION="The GNU Compiler Collection.  Includes C/C++, java compilers, pie+ssp extensions, Haj Ten Brugge runtime bounds checking. This Compiler is based off of Crosstoolv14."

LICENSE="GPL-3 LGPL-3 || ( GPL-3 libgcc libstdc++ gcc-runtime-library-exception-3.1 ) FDL-1.2"
KEYWORDS="~alpha ~amd64 ~arm -hppa ~ia64 ~mips ~ppc ~ppc64 ~sh -sparc ~x86 ~x86-fbsd"

RDEPEND=">=sys-libs/zlib-1.1.4
	>=sys-devel/gcc-config-1.4
	virtual/libiconv
	>=dev-libs/gmp-4.2.1
	>=dev-libs/mpc-0.8.1
	>=dev-libs/mpfr-2.3.2
	graphite? (
		>=dev-libs/ppl-0.10
		>=dev-libs/cloog-ppl-0.15.4
	)
	!build? (
		gcj? (
			gtk? (
				x11-libs/libXt
				x11-libs/libX11
				x11-libs/libXtst
				x11-proto/xproto
				x11-proto/xextproto
				>=x11-libs/gtk+-2.2
				x11-libs/pango
			)
			>=media-libs/libart_lgpl-2.1
			app-arch/zip
			app-arch/unzip
		)
		>=sys-libs/ncurses-5.2-r2
		nls? ( sys-devel/gettext )
	)"
DEPEND="${RDEPEND}
	test? ( >=dev-util/dejagnu-1.4.4 >=sys-devel/autogen-5.5.4 )
	>=sys-apps/texinfo-4.8
	>=sys-devel/bison-1.875
	elibc_glibc? ( >=sys-libs/glibc-2.8 )
	amd64? ( multilib? ( gcj? ( app-emulation/emul-linux-x86-xlibs ) ) )
	ppc? ( >=${CATEGORY}/binutils-2.17 )
	ppc64? ( >=${CATEGORY}/binutils-2.17 )
	>=${CATEGORY}/binutils-2.15.94"
PDEPEND=">=sys-devel/gcc-config-1.4"
if [[ ${CATEGORY} != cross-* ]] ; then
	PDEPEND="${PDEPEND} elibc_glibc? ( >=sys-libs/glibc-2.8 )"
fi

RESTRICT="mirror strip"

IUSE="gcj graphite gtk hardened hardfp mounted_sources multislot nls nocxx
			svn_sources +thumb upstream_gcc vanilla"

if [[ "${PV}" == "9999" ]]
then
	if [[ -z $GCC_PV ]]
	then
		GCC_PV=4.4.3
	fi
else
	GCC_PV=${PV}
fi
MY_P=${PN}-${GCC_PV}
GITDIR=${WORKDIR}/gitdir
GITHASH=1b70b8f872d862dfed84e7d99d1369855c063ca9

is_crosscompile() { [[ ${CHOST} != ${CTARGET} ]] ; }

export CTARGET=${CTARGET:-${CHOST}}
if [[ ${CTARGET} = ${CHOST} ]] ; then
	if [[ ${CATEGORY/cross-} != ${CATEGORY} ]] ; then
		export CTARGET=${CATEGORY/cross-}
	fi
fi

if use multislot ; then
	SLOT="${CTARGET}-${PV}"
else
	SLOT="${CTARGET}"
fi

PREFIX=/usr
LIBDIR=${PREFIX}/lib/gcc/${CTARGET}/${GCC_PV}
INCLUDEDIR=${LIBDIR}/include
if is_crosscompile ; then
	BINDIR=${PREFIX}/${CHOST}/${CTARGET}/gcc-bin/${GCC_PV}
else
	BINDIR=${PREFIX}/${CTARGET}/gcc-bin/${GCC_PV}
fi
DATADIR=${PREFIX}/share/gcc-data/${CTARGET}/${GCC_PV}
STDCXX_INCDIR=${LIBDIR}/include/g++-v${GCC_PV}


src_unpack() {
	GCC_CONFIG_FILE=${CTARGET}-${GCC_PV}

	local GCCDIR
	if use mounted_sources ; then
		GCCDIR=/usr/local/toolchain_root/gcc/${MY_P}
		if [[ ! -d ${GCCDIR} ]] ; then
			die "gcc dir not mounted/present at: ${GCCDIR}"
		fi
	elif use svn_sources ; then
		SVNDIR=svn
		GCCDIR=${SVNDIR}/gcc/${MY_P}
		MAJOR_VERSION=$(echo ${GCC_PV} | sed 's/\./ /g' | awk '{print $1}')
		MINOR_VERSION=$(echo ${GCC_PV} | sed 's/\./ /g' | awk '{print $2}')
		svn co svn://gcc.gnu.org/svn/gcc/branches/google/gcc-${MAJOR_VERSION}_${MINOR_VERSION} ${GCCDIR}
		CL=$(cd ${GCCDIR}; svnversion)
	else
		mkdir ${GITDIR}
		cd ${GITDIR} || die "Could not enter ${GITDIR}"
		git clone http://git.chromium.org/chromiumos/third_party/gcc.git . || die "Could not clone repo."
		if [[ "${PV}" != "${GCC_PV}" ]] ; then
			GITHASH=$(git rev-list --max-count=1 --all)
			echo "Getting latest hash: ${GITHASH}..."
		fi
		git checkout ${GITHASH} || die "Could not checkout ${GITHASH}"
		cd -
		GCCDIR=${GITDIR}/gcc/${MY_P}
		CL=$(cd ${GITDIR}; git log --pretty=format:%s -n1 | grep -o '[0-9]\+')
	fi

	if use upstream_gcc ; then
		GCC_MIRROR=ftp://mirrors.kernel.org/gnu/gcc
		GCC_TARBALL=${GCC_MIRROR}/${MY_P}/${MY_P}.tar.bz2
		wget $GCC_TARBALL
		tar xf ${GCC_TARBALL##*/}
		GCCDIR=${MY_P}
	fi

	GCC_BASE_VER=$(cat ${GCCDIR}/gcc/BASE-VER)
	SLIBDIR=${LIBDIR}/gcc/${CTARGET}/${GCC_BASE_VER}

	if [[ ! -z ${CL} ]] ; then
		COST_PKG_VERSION="${COST_PKG_VERSION}_${CL}"
	fi

	if [[ $(readlink -f ${GCCDIR}) != $(readlink -f ${S}) ]]
	then
		ln -sf ${GCCDIR} ${S}
	fi

	use vanilla && return 0
}

src_compile()
{
	src_configure
	pushd ${WORKDIR}/build
	GCC_CFLAGS="$(portageq envvar CFLAGS)"
	if use hardened && [[ ${CTARGET} != arm* ]] && [[ "$GCC_PV" == "4.4.3" ]]
	then
		GCC_CFLAGS+=" -DEFAULT_PIE_SSP -DEFAULT_BIND_NOW -DEFAULT_FORTIFY_SOURCE -DEFAULT_RELRO"
	fi
	emake CFLAGS="${GCC_CFLAGS}" LDFLAGS=-Wl,-O1 'STAGE1_CFLAGS=-O2 -pipe' BOOT_CFLAGS=-O2 all
	popd
	return $?
}

src_install()
{
	cd ${WORKDIR}/build
	emake DESTDIR="${D}" install || die "Could not install gcc"

	find "${D}" -name libiberty.a -exec rm -f "{}" \;

	dodir /etc/env.d/gcc
	insinto /etc/env.d/gcc
	cat <<-EOF > env.d
LDPATH="${LIBDIR}/gcc/${CTARGET}/${GCC_BASE_VER}"
MANPATH="${DATADIR}/man"
INFOPATH="${DATADIR}/info"
STDCXX_INCDIR="${STDCXX_INCDIR}"
CTARGET=${CTARGET}
GCC_PATH="${BINDIR}"
EOF
	newins env.d $GCC_CONFIG_FILE
	cd -

	if use hardened && [[ ${CTARGET} != arm* ]] && [[ "$GCC_PV" != "4.4.3" ]]
	then
		SYSROOT_WRAPPER_FILE=sysroot_wrapper.hardened
	else
		SYSROOT_WRAPPER_FILE=sysroot_wrapper
	fi

	cd ${D}${BINDIR}
	exeinto "${BINDIR}"
	doexe "${FILESDIR}/${SYSROOT_WRAPPER_FILE}" || die
	for x in c++ cpp g++ gcc; do
		if [[ -f "${CTARGET}-${x}" ]]; then
			mv "${CTARGET}-${x}" "${CTARGET}-${x}.real"
			dosym "${SYSROOT_WRAPPER_FILE}" "${BINDIR}/${CTARGET}-${x}" || die
		fi
	done
}

pkg_postinst()
{
	gcc-config $GCC_CONFIG_FILE
	CCACHE_BIN=$(which ccache || true)
	if is_crosscompile && [[ -f "${CCACHE_BIN}" ]] ; then
		mkdir -p "/usr/lib/ccache/bin"
		for x in c++ cpp g++ gcc; do
			dosym "${CCACHE_BIN}" "/usr/lib/ccache/bin/${CTARGET}-${x}" || die
		done
	fi
}

pkg_postrm()
{
	if is_crosscompile ; then
		if [[ -z $(ls "${ROOT}"/etc/env.d/gcc/${CTARGET}* 2>/dev/null) ]] ; then
			rm -f "${ROOT}"/etc/env.d/gcc/config-${CTARGET}
			rm -f "${ROOT}"/etc/env.d/??gcc-${CTARGET}
			rm -f "${ROOT}"/usr/bin/${CTARGET}-{gcc,{g,c}++}{,32,64}
		fi
	fi
	if is_crosscompile &&
		[[ $(equery l gcc | grep i686-pc-linux-gnu | wc -l) -eq 1 ]] ; then
		for x in c++ cpp g++ gcc; do
			rm -rf "/usr/lib/ccache/bin/${CTARGET}-${x}"
		done
	fi
}

src_configure()
{
	if use mounted_sources ; then
		local GCCBUILDDIR="/usr/local/toolchain_root/build-gcc"
		if [[ ! -d ${GCCBUILDDIR} ]] ; then
			die "build-gcc dir not mounted/present at: ${GCCBUILDIR}"
		fi
	else
		local GCCBUILDDIR="${GITDIR}/build-gcc"
	fi

	local confgcc
	# Set configuration based on path variables
	confgcc="${confgcc} \
		--prefix=${PREFIX} \
		--with-slibdir=${SLIBDIR} \
		--libdir=${LIBDIR} \
		--bindir=${BINDIR} \
		--includedir=${INCLUDEDIR} \
		--datadir=${DATADIR} \
		--mandir=${DATADIR}/man \
		--infodir=${DATADIR}/info \
		--enable-version-specific-runtime-libs
		--with-gxx-include-dir=${STDCXX_INCDIR}"
	confgcc="${confgcc} --host=${CHOST}"
	confgcc="${confgcc} --target=${CTARGET}"
	confgcc="${confgcc} --build=${CBUILD}"

	# Language options for stage1/stage2.
	if use nocxx
	then
		GCC_LANG="c"
	else
		GCC_LANG="c,c++"
	fi
	confgcc="${confgcc} --enable-languages=${GCC_LANG}"

	if use hardfp && [[ ${CTARGET} == arm* ]] ;
	then
		confgcc="${confgcc} --with-float=hard"
	fi

	if use thumb && [[ ${CTARGET} == arm* ]] ;
	then
		confgcc="${confgcc} --with-mode=thumb"
	fi

	local needed_libc="glibc"
	if [[ -n ${needed_libc} ]] ; then
		if ! has_version ${CATEGORY}/${needed_libc} ; then
			confgcc="${confgcc} --disable-shared --disable-threads --without-headers"
		elif built_with_use --hidden --missing false ${CATEGORY}/${needed_libc} crosscompile_opts_headers-only ; then
			confgcc="${confgcc} --disable-shared --with-sysroot=/usr/${CTARGET}"
		else
			confgcc="${confgcc} --with-sysroot=/usr/${CTARGET}"
		fi
	fi

	confgcc="${confgcc} $(get_gcc_configure_options ${CTARGET})"

	EXTRA_ECONF="--with-bugurl=http://code.google.com/p/chromium-os/issues/entry\
    --with-pkgversion=${COST_PKG_VERSION} --enable-linker-build-id"
	confgcc="${confgcc} ${EXTRA_ECONF}"

	# Build in a separate build tree
	mkdir -p "${WORKDIR}"/build
	pushd "${WORKDIR}"/build > /dev/null

	# and now to do the actual configuration
	addwrite /dev/zero
	echo "Running this:"
	echo "configure ${confgcc}"
	echo "${S}"/configure "$@"
	"${S}"/configure ${confgcc} || die "failed to run configure"
	popd > /dev/null
}

get_gcc_configure_options()
{
	local CTARGET=$1; shift
	local confgcc=$(get_gcc_common_options)
	case ${CTARGET} in
		arm*)	#264534
			local arm_arch="${CTARGET%%-*}"
			# Only do this if arm_arch is armv*
			if [[ ${arm_arch} == armv* ]] ; then
				# Convert armv7{a,r,m} to armv7-{a,r,m}
				[[ ${arm_arch} == armv7? ]] && arm_arch=${arm_arch/7/7-}
				# Remove endian ('l' / 'eb')
				[[ ${arm_arch} == *l  ]] && arm_arch=${arm_arch%l}
				[[ ${arm_arch} == *eb ]] && arm_arch=${arm_arch%eb}
				confgcc="${confgcc} --with-arch=${arm_arch}"
				confgcc="${confgcc} --disable-esp"
			fi
			;;
		i?86*)
			# Hardened is enabled for x86, but disabled for ARM.
			confgcc="${confgcc} --enable-esp"
			confgcc="${confgcc} --with-arch=atom"
			confgcc="${confgcc} --with-tune=atom"
			;;
	esac
	echo ${confgcc}
}

get_gcc_common_options()
{
	local confgcc
	confgcc="${confgcc} --disable-libmudflap"
	confgcc="${confgcc} --disable-libssp"
	confgcc="${confgcc} --disable-libgomp"
	confgcc="${confgcc} --enable-__cxa_atexit"
	confgcc="${confgcc} --enable-checking=release"
	confgcc="${confgcc} --disable-libquadmath"
	echo ${confgcc}
}

