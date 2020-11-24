# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-devel/gcc/gcc-4.4.3-r3.ebuild,v 1.1 2010/06/19 01:53:09 zorry Exp $

EAPI="7"
CROS_WORKON_COMMIT="ac6128e0a17a52f011797f33ac3e7d6273a9368d"
CROS_WORKON_TREE="aff2e49c815be09f20e4346cc98144b604388cb7"
CROS_WORKON_REPO="https://android.googlesource.com"
CROS_WORKON_PROJECT="toolchain/gcc"
CROS_WORKON_LOCALNAME=../aosp/toolchain/gcc
NEXT_GCC="origin/svn-mirror/google/gcc-4_9"
NEXT_GCC_REPO="https://chromium.googlesource.com/chromiumos/third_party/gcc.git"

# By default, PREV_GCC points to the parent of current tip of origin/master.
# If that is a bad commit, override this to point to the last known good commit.
PREV_GCC="origin/master^"

inherit eutils cros-workon binutils-funcs

GCC_FILESDIR="${PORTDIR}/sys-devel/gcc/files"

DESCRIPTION="The GNU Compiler Collection.  Includes C/C++, java compilers, pie+ssp extensions, Haj Ten Brugge runtime bounds checking. This Compiler is based off of Crosstoolv14."

LICENSE="GPL-3 LGPL-3 libgcc FDL-1.2"
KEYWORDS="*"

RDEPEND=">=sys-libs/zlib-1.1.4
	>=sys-devel/gcc-config-1.6
	virtual/libiconv
	>=dev-libs/gmp-4.3.2
	>=dev-libs/mpc-0.8.1
	>=dev-libs/mpfr-2.4.2
	graphite? (
		>=dev-libs/cloog-0.18.0
		>=dev-libs/isl-0.11.1
	)"
DEPEND="${RDEPEND}
	test? (
		>=dev-util/dejagnu-1.4.4
		>=sys-devel/autogen-5.5.4
	)
	>=sys-apps/texinfo-4.8
	>=sys-devel/bison-1.875"
PDEPEND=">=sys-devel/gcc-config-1.7"
BDEPEND="${CATEGORY}/binutils"

RESTRICT="mirror strip"

IUSE="gcc_repo gcj git_gcc go graphite gtk hardened hardfp llvm-next llvm-tot mounted_gcc multilib
	nls cxx openmp test tests +thumb upstream_gcc vanilla vtable_verify +wrapper_ccache
	next_gcc prev_gcc"
REQUIRED_USE="next_gcc? ( !prev_gcc )"

is_crosscompile() { [[ ${CHOST} != ${CTARGET} ]] ; }

export CTARGET=${CTARGET:-${CHOST}}
if [[ ${CTARGET} = ${CHOST} ]] ; then
	if [[ ${CATEGORY/cross-} != ${CATEGORY} ]] ; then
		export CTARGET=${CATEGORY/cross-}
	fi
fi

SLOT="${CTARGET}"

PREFIX=/usr

update_location_for_aosp() {
	# For aosp gcc repository, the actual gcc directory is 1 more
	# level down, eg. gcc/gcc-4.9, pick up the newest one in this
	# case.
	local gccsub=$(find "${S}" -maxdepth 1 -type d -name "gcc-*" | sort -r | head -1)
	if [[ -d "${gccsub}" ]] && [[ -d "${gccsub}/gcc/config/arm/" ]]; then
		S="${gccsub}"
	fi
	cd "${S}"
}

cros_pre_src_prepare_use_gcc() {
	cros_use_gcc
}

src_unpack() {
	if use mounted_gcc ; then
		if [[ ! -d "$(get_gcc_dir)" ]] ; then
			die "gcc dir not mounted/present at: $(get_gcc_dir)"
		fi
		S=$(get_gcc_dir)
	elif use upstream_gcc ; then
		GCC_MIRROR=ftp://mirrors.kernel.org/gnu/gcc
		GCC_TARBALL=${GCC_MIRROR}/${P}/${P}.tar.bz2
		wget $GCC_TARBALL
		tar xf ${GCC_TARBALL##*/}
	elif use git_gcc || use next_gcc || use prev_gcc ; then
		aosp_git="${CROS_WORKON_REPO}/${CROS_WORKON_PROJECT}.git"
		if use gcc_repo ; then
			gcc_repository="${GCC_REPO}"
		elif use next_gcc ; then
			gcc_repository="${NEXT_GCC_REPO}"
		else
			gcc_repository="${aosp_git}"
		fi
		git clone --depth 1 --no-single-branch "${gcc_repository}" "${S}"
		if use next_gcc ; then
			GCC_GITHASH="${NEXT_GCC}"
		fi
		if use prev_gcc ; then
			GCC_GITHASH="${PREV_GCC}"
		fi
		if [[ -n ${GCC_GITHASH} ]] ; then
			einfo "Checking out: ${GCC_GITHASH}"
			pushd "$(get_gcc_dir)" >/dev/null
			git checkout ${GCC_GITHASH} || \
				die "Couldn't checkout ${GCC_GITHASH}"
			popd >/dev/null
		fi
		if [[ ${gcc_repository} == "${aosp_git}" ]] ; then
			update_location_for_aosp
		fi
	else
		cros-workon_src_unpack
		update_location_for_aosp
		[[ ${ABI} == "x32" ]] && eapply "${FILESDIR}"/90_all_gcc-4.7-x32.patch
	fi

	COST_PKG_VERSION="$("${FILESDIR}"/chromeos-version.sh "${S}")_cos_gg"
	if [[ -d ${S}/.git ]]; then
		COST_PKG_VERSION+="_$(cd ${S}; git describe --always)"
	elif [[ -n ${VCSID} ]]; then
		COST_PKG_VERSION+="_${VCSID}"
	fi
	COST_PKG_VERSION+="_${PVR}"
}

src_configure() {
	if use mounted_gcc && [[ -f $(get_gcc_build_dir)/Makefile ]]; then
		ewarn "Skipping configure due to existing build output"
		return
	fi

	# GCC builds do not like LD being set, it will find correct LD to use.
	unset LD BUILD_LD

	local gcc_langs="c"
	use cxx && gcc_langs+=",c++"
	use go && gcc_langs+=",go"

	# Set configuration based on path variables
	local DATAPATH=$(get_data_dir)
	local confgcc=(
		--prefix=${PREFIX}
		--bindir=$(get_bin_dir)
		--datadir=${DATAPATH}
		--includedir=$(get_lib_dir)/include
		--with-gxx-include-dir=$(get_stdcxx_incdir)
		--mandir=${DATAPATH}/man
		--infodir=${DATAPATH}/info
		--with-python-dir=${DATAPATH#${PREFIX}}/python

		--build=${CBUILD}
		--host=${CHOST}
		--target=${CTARGET}
		--enable-languages=${gcc_langs}
		--enable-__cxa_atexit
		--disable-canonical-system-headers
		--enable-checking=release
		--enable-linker-build-id

		--with-bugurl='http://code.google.com/p/chromium-os/issues/entry'
		--with-pkgversion="${COST_PKG_VERSION}"

		$(use_enable go libatomic)
		$(use_enable multilib)
		$(use_enable openmp libgomp)

		# Disable libs we don't care about.
		--disable-libcilkrts
		--disable-libitm
		--disable-libmudflap
		--disable-libquadmath
		--disable-libssp
		--disable-libsanitizer

		# Enable frame pointer by default for all the boards.
		# originally only enabled for i686 for chromium-os:23321.
		--enable-frame-pointer
	)

	if use vtable_verify; then
		confgcc+=(
			--enable-cxx-flags=-Wl,-L../libsupc++/.libs
			--enable-vtable-verify
		)
	fi

	# Handle target-specific options.
	case ${CTARGET} in
	arm*)	#264534
		local arm_arch="${CTARGET%%-*}"
		# Only do this if arm_arch is armv*
		if [[ ${arm_arch} == armv* ]]; then
			# Convert armv7{a,r,m} to armv7-{a,r,m}
			[[ ${arm_arch} == armv7? ]] && arm_arch=${arm_arch/7/7-}
			# Remove endian ('l' / 'eb')
			[[ ${arm_arch} == *l ]] && arm_arch=${arm_arch%l}
			[[ ${arm_arch} == *eb ]] && arm_arch=${arm_arch%eb}
			confgcc+=(
				--with-arch=${arm_arch}
				--disable-esp
			)
		fi
		use hardfp && confgcc+=( --with-float=hard )
		use thumb && confgcc+=( --with-mode=thumb )
		;;
	i?86*)
		# Hardened is enabled for x86, but disabled for ARM.
		confgcc+=(
			--enable-esp
			--with-arch=atom
			--with-tune=atom
		)
		;;
	x86_64*-gnux32)
		confgcc+=( --with-abi=x32 --with-multilib-list=mx32 )
		;;
	esac

	if is_crosscompile; then
		confgcc+=( --enable-poison-system-directories )

		local needed_libc="glibc"
		if [[ -n ${needed_libc} ]]; then
			if ! has_version ${CATEGORY}/${needed_libc}; then
				confgcc+=( --disable-shared --disable-threads --without-headers )
			elif has_version "${CATEGORY}/${needed_libc}[crosscompile_opts_headers-only]"; then
				confgcc+=( --disable-shared --with-sysroot=/usr/${CTARGET} )
			else
				confgcc+=( --with-sysroot=/usr/${CTARGET} )
			fi
		fi
	else
		confgcc+=( --enable-shared --enable-threads=posix )
	fi

	# Finally add the user options (if any).
	confgcc+=( ${EXTRA_ECONF} )

	# Build in a separate build tree
	mkdir -p $(get_gcc_build_dir) || die
	cd $(get_gcc_build_dir) || die

	# and now to do the actual configuration
	addwrite /dev/zero
	echo "Running this:"
	echo "$(get_gcc_dir)"/configure "${confgcc[@]}"
	"$(get_gcc_dir)"/configure "${confgcc[@]}" || die
}

src_compile() {
	cd "$(get_gcc_build_dir)"
	GCC_CFLAGS="$(portageq envvar CFLAGS)"
	TARGET_FLAGS=""
	TARGET_GO_FLAGS=""

	if use hardened ; then
		TARGET_FLAGS="${TARGET_FLAGS} -fstack-protector-strong -D_FORTIFY_SOURCE=2"
	fi

	EXTRA_CFLAGS_FOR_TARGET="${TARGET_FLAGS} ${CFLAGS_FOR_TARGET}"
	EXTRA_CXXFLAGS_FOR_TARGET="${TARGET_FLAGS} ${CXXFLAGS_FOR_TARGET}"

	if use vtable_verify ; then
		EXTRA_CXXFLAGS_FOR_TARGET+=" -fvtable-verify=std"
	fi

	# libgo on arm must be compiled with -marm. Go's panic/recover functionality
	# is broken in thumb mode.
	if [[ ${CTARGET} == arm* ]]; then
		TARGET_GO_FLAGS="${TARGET_GO_FLAGS} -marm"
	fi
	EXTRA_GOCFLAGS_FOR_TARGET="${TARGET_GO_FLAGS} ${GOCFLAGS_FOR_TARGET}"

	# Do not link libgcc with gold. That is known to fail on internal linker
	# errors. See crosbug.com/16719
	local LD_NON_GOLD="$(get_binutils_path_ld ${CTARGET})/ld"

	emake CFLAGS="${GCC_CFLAGS}" \
		LDFLAGS="-Wl,-O1" \
		STAGE1_CFLAGS="-O2 -pipe" \
		BOOT_CFLAGS="-O2" \
		CFLAGS_FOR_TARGET="$(get_make_var CFLAGS_FOR_TARGET) ${EXTRA_CFLAGS_FOR_TARGET}" \
		CXXFLAGS_FOR_TARGET="$(get_make_var CXXFLAGS_FOR_TARGET) ${EXTRA_CXXFLAGS_FOR_TARGET}" \
		GOCFLAGS_FOR_TARGET="$(get_make_var GOCFLAGS_FOR_TARGET) ${EXTRA_GOCFLAGS_FOR_TARGET}" \
		LD_FOR_TARGET="${LD_NON_GOLD}" \
		all
}

# Logic copied from Gentoo's toolchain.eclass.
toolchain_src_install() {
	BINPATH=$(get_bin_dir) # cros to Gentoo glue

	# These should be symlinks
	dodir /usr/bin
	cd "${D}"${BINPATH}
	for x in cpp gcc g++ c++ gcov g77 gcj gcjh gfortran gccgo ; do
		# For some reason, g77 gets made instead of ${CTARGET}-g77...
		# this should take care of that
		[[ -f ${x} ]] && mv ${x} ${CTARGET}-${x}

		if [[ -f ${CTARGET}-${x} ]] ; then
			if ! is_crosscompile ; then
				ln -sf ${CTARGET}-${x} ${x}
				dosym ${BINPATH}/${CTARGET}-${x} \
					/usr/bin/${x}-${GCC_CONFIG_VER}
			fi

			# Create version-ed symlinks
			dosym ${BINPATH}/${CTARGET}-${x} \
				/usr/bin/${CTARGET}-${x}-${GCC_CONFIG_VER}
		fi

		if [[ -f ${CTARGET}-${x}-${GCC_CONFIG_VER} ]] ; then
			rm -f ${CTARGET}-${x}-${GCC_CONFIG_VER}
			ln -sf ${CTARGET}-${x} ${CTARGET}-${x}-${GCC_CONFIG_VER}
		fi
	done
}

src_install() {
	cd "$(get_gcc_build_dir)"
	emake DESTDIR="${D}" install

	find "${D}" -name libiberty.a -exec rm -f "{}" \;

	# Move the libraries to the proper location
	gcc_movelibs

	# Move pretty-printers to gdb datadir to shut ldconfig up
	gcc_move_pretty_printers

	GCC_CONFIG_VER=$(get_gcc_base_ver)
	dodir /etc/env.d/gcc
	insinto /etc/env.d/gcc

	local LDPATH=$(get_lib_dir)
	for SUBDIR in 32 64 ; do
		if [[ -d ${D}/${LDPATH}/${SUBDIR} ]]
		then
			LDPATH="${LDPATH}:${LDPATH}/${SUBDIR}"
		fi
	done

	cat <<-EOF > env.d
LDPATH="${LDPATH}"
MANPATH="$(get_data_dir)/man"
INFOPATH="$(get_data_dir)/info"
STDCXX_INCDIR="$(get_stdcxx_incdir)"
CTARGET=${CTARGET}
GCC_PATH="$(get_bin_dir)"
GCC_VER="$(get_gcc_base_ver)"
EOF
	newins env.d $(get_gcc_config_file)
	cd -

	toolchain_src_install

	cd "${D}$(get_bin_dir)"

	local use_llvm_next=false
	if use llvm-next || use llvm-tot
	then
		use_llvm_next=true
	fi

	if is_crosscompile ; then
		local sysroot_wrapper_file_prefix
		local sysroot_wrapper_config
		if use hardened
		then
			sysroot_wrapper_file_prefix=sysroot_wrapper.hardened
			sysroot_wrapper_config=cros.hardened
		else
			sysroot_wrapper_file_prefix=sysroot_wrapper
			sysroot_wrapper_config=cros.nonhardened
		fi

		exeinto "$(get_bin_dir)"
		cat "${FILESDIR}/bisect_driver.py" > \
			"${D}$(get_bin_dir)/bisect_driver.py" || die

		# Note: We are always producing both versions, with and without ccache,
		# so we can replace the behavior of the wrapper without rebuilding it.
		# Used e.g. in chromite/scripts/cros_setup_toolchains.py to disable the
		# ccache for simplechrome toolchains.
		local ccache_suffixes=(noccache ccache)
		local ccache_option_values=(false true)
		for ccache_index in {0,1}; do
			local ccache_suffix="${ccache_suffixes[${ccache_index}]}"
			local ccache_option="${ccache_option_values[${ccache_index}]}"
			# Build new golang wrapper
			"${FILESDIR}/compiler_wrapper/build.py" --config="${sysroot_wrapper_config}" \
				--use_ccache="${ccache_option}" \
				--use_llvm_next="${use_llvm_next}" \
				--output_file="${D}$(get_bin_dir)/${sysroot_wrapper_file_prefix}.${ccache_suffix}" || die
		done

		local use_ccache_index
		use_ccache_index="$(usex wrapper_ccache 1 0)"
		local sysroot_wrapper_file="${sysroot_wrapper_file_prefix}.${ccache_suffixes[${use_ccache_index}]}"

		for x in c++ g++ gcc; do
			if [[ -f "${CTARGET}-${x}" ]]; then
				mv "${CTARGET}-${x}" "${CTARGET}-${x}.real"
				dosym "${sysroot_wrapper_file}" "$(get_bin_dir)/${CTARGET}-${x}" || die
			fi
		done
		for x in clang clang++; do
			dosym "${sysroot_wrapper_file}" "$(get_bin_dir)/${CTARGET}-${x}" || die
		done
		if use go; then
			local wrapper="sysroot_wrapper.gccgo"
			doexe "${FILESDIR}/${wrapper}" || die
			mv "${CTARGET}-gccgo" "${CTARGET}-gccgo.real" || die
			dosym "${wrapper}" "$(get_bin_dir)/${CTARGET}-gccgo" || die
		fi
	else
		local sysroot_wrapper_file=host_wrapper

		exeinto "$(get_bin_dir)"

		"${FILESDIR}/compiler_wrapper/build.py" --config=cros.host --use_ccache=false \
			--use_llvm_next="${use_llvm_next}" \
			--output_file="${D}$(get_bin_dir)/${sysroot_wrapper_file}" || die

		for x in c++ g++ gcc; do
			if [[ -f "${CTARGET}-${x}" ]]; then
				mv "${CTARGET}-${x}" "${CTARGET}-${x}.real"
				dosym "${sysroot_wrapper_file}" "$(get_bin_dir)/${CTARGET}-${x}" || die
			fi
			if [[ -f "${x}" ]]; then
				ln "${CTARGET}-${x}.real" "${x}.real" || die
				rm "${x}" || die
				dosym "${sysroot_wrapper_file}" "$(get_bin_dir)/${x}" || die
				# Add a cc.real symlink that points to gcc.real, https://crbug.com/1090449
				if [[ "${x}" == "gcc" ]]; then
					dosym "${x}.real" "$(get_bin_dir)/cc.real"
				fi
			fi
		done
	fi

	if use tests
	then
		TEST_INSTALL_DIR="usr/local/dejagnu/gcc"
		dodir ${TEST_INSTALL_DIR}
		cd ${D}/${TEST_INSTALL_DIR}
		tar -czf "tests.tar.gz" ${WORKDIR}
	fi
}

pkg_postinst() {
	gcc-config $(get_gcc_config_file)
}

pkg_postrm() {
	if is_crosscompile ; then
		if [[ -z $(ls "${ROOT}"/etc/env.d/gcc/${CTARGET}* 2>/dev/null) ]] ; then
			rm -f "${ROOT}"/etc/env.d/gcc/config-${CTARGET}
			rm -f "${ROOT}"/etc/env.d/??gcc-${CTARGET}
			rm -f "${ROOT}"/usr/bin/${CTARGET}-{gcc,{g,c}++}{,32,64}
		fi
	fi
}

get_gcc_dir() {
	local GCCDIR
	if use mounted_gcc ; then
		GCCDIR=${GCC_SOURCE_PATH:=/usr/local/toolchain_root/gcc}
	elif use upstream_gcc ; then
		GCCDIR=${P}
	else
		GCCDIR=${S}
	fi
	echo "${GCCDIR}"
}

get_gcc_build_dir() {
	echo "$(get_gcc_dir)-build-${CTARGET}"
}

get_gcc_base_ver() {
	cat "$(get_gcc_dir)/gcc/BASE-VER"
}

get_stdcxx_incdir() {
	echo "$(get_lib_dir)/include/g++-v4"
}

get_lib_dir() {
	echo "${PREFIX}/lib/gcc/${CTARGET}/$(get_gcc_base_ver)"
}

get_bin_dir() {
	if is_crosscompile ; then
		echo ${PREFIX}/${CHOST}/${CTARGET}/gcc-bin/$(get_gcc_base_ver)
	else
		echo ${PREFIX}/${CTARGET}/gcc-bin/$(get_gcc_base_ver)
	fi
}

get_data_dir() {
	echo "${PREFIX}/share/gcc-data/${CTARGET}/$(get_gcc_base_ver)"
}

get_gcc_config_file() {
	echo ${CTARGET}-${PV}
}

# Grab a variable from the build system (taken from linux-info.eclass)
get_make_var() {
	local var=$1 makefile=${2:-$(get_gcc_build_dir)/Makefile}
	echo -e "e:\\n\\t@echo \$(${var})\\ninclude ${makefile}" | \
		r=${makefile%/*} emake --no-print-directory -s -f - 2>/dev/null
}
XGCC() { get_make_var GCC_FOR_TARGET ; }

gcc_move_pretty_printers() {
	LIBPATH=$(get_lib_dir)  # cros to Gentoo glue

	local py gdbdir=/usr/share/gdb/auto-load${LIBPATH}
	pushd "${D}"${LIBPATH} >/dev/null
	for py in $(find . -name '*-gdb.py') ; do
		local multidir=${py%/*}
		insinto "${gdbdir}/${multidir}"
		sed -i "/^libdir =/s:=.*:= '${LIBPATH}/${multidir}':" "${py}" || die #348128
		doins "${py}" || die
		rm "${py}" || die
	done
	popd >/dev/null
}

# make sure the libtool archives have libdir set to where they actually
# -are-, and not where they -used- to be.  also, any dependencies we have
# on our own .la files need to be updated.
fix_libtool_libdir_paths() {
	pushd "${D}" >/dev/null

	pushd "./${1}" >/dev/null
	local dir="${PWD#${D%/}}"
	local allarchives=$(echo *.la)
	allarchives="\(${allarchives// /\\|}\)"
	popd >/dev/null

	sed -i \
		-e "/^libdir=/s:=.*:='${dir}':" \
		./${dir}/*.la
	sed -i \
		-e "/^dependency_libs=/s:/[^ ]*/${allarchives}:${LIBPATH}/\1:g" \
		$(find ./${PREFIX}/lib* -maxdepth 3 -name '*.la') \
		./${dir}/*.la

	popd >/dev/null
}

gcc_movelibs() {
	LIBPATH=$(get_lib_dir)	# cros to Gentoo glue

	local multiarg removedirs=""
	for multiarg in $($(XGCC) -print-multi-lib) ; do
		multiarg=${multiarg#*;}
		multiarg=${multiarg//@/ -}

		local OS_MULTIDIR=$($(XGCC) ${multiarg} --print-multi-os-directory)
		local MULTIDIR=$($(XGCC) ${multiarg} --print-multi-directory)
		local TODIR=${D}${LIBPATH}/${MULTIDIR}
		local FROMDIR=

		[[ -d ${TODIR} ]] || mkdir -p ${TODIR}

		for FROMDIR in \
			${LIBPATH}/${OS_MULTIDIR} \
			${LIBPATH}/../${MULTIDIR} \
			${PREFIX}/lib/${OS_MULTIDIR} \
			${PREFIX}/${CTARGET}/lib/${OS_MULTIDIR}
		do
			removedirs="${removedirs} ${FROMDIR}"
			FROMDIR=${D}${FROMDIR}
			if [[ ${FROMDIR} != "${TODIR}" && -d ${FROMDIR} ]] ; then
				local files=$(find "${FROMDIR}" -maxdepth 1 ! -type d 2>/dev/null)
				if [[ -n ${files} ]] ; then
					mv ${files} "${TODIR}"
				fi
			fi
		done
		fix_libtool_libdir_paths "${LIBPATH}/${MULTIDIR}"
	done

	# We remove directories separately to avoid this case:
	#	mv SRC/lib/../lib/*.o DEST
	#	rmdir SRC/lib/../lib/
	#	mv SRC/lib/../lib32/*.o DEST  # Bork
	for FROMDIR in ${removedirs} ; do
		rmdir "${D}"${FROMDIR} >& /dev/null
	done
	find "${D}" -type d | xargs rmdir >& /dev/null
}

# If you need to force a cros_workon uprev, change this number (you can use next
# uprev): 274
