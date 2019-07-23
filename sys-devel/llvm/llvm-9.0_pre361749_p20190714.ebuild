# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

: ${CMAKE_MAKEFILE_GENERATOR:=ninja}
PYTHON_COMPAT=( python2_7 )

inherit  cros-constants check-reqs cmake-utils eutils flag-o-matic git-2 git-r3 \
	multilib multilib-minimal python-single-r1 toolchain-funcs pax-utils

# llvm:361749 https://critique.corp.google.com/#review/252092293
# Master bug: crbug/972454
LLVM_HASH="c11de5eada2decd0a495ea02676b6f4838cd54fb" # r361749
LLVM_NEXT_HASH="6b043f051836635a1e88da4d0464e6569bd7b625" # r365631

DESCRIPTION="Low Level Virtual Machine"
HOMEPAGE="http://llvm.org/"
SRC_URI="
	!llvm-tot? (
		!llvm-next? ( llvm_pgo_use? ( gs://chromeos-localmirror/distfiles/llvm-profdata-${LLVM_HASH}.tar.xz ) )
		llvm-next? ( llvm-next_pgo_use? ( gs://chromeos-localmirror/distfiles/llvm-profdata-${LLVM_NEXT_HASH}.tar.xz ) )
	)
"
EGIT_REPO_URI="${CROS_GIT_HOST_URL}/external/github.com/llvm/llvm-project"

LICENSE="UoI-NCSA"
SLOT="8"
KEYWORDS="-* amd64"
IUSE="debug +default-compiler-rt +default-libcxx doc libedit +libffi llvm-next
	llvm_pgo_generate +llvm_pgo_use llvm-next_pgo_use llvm-tot multitarget
	ncurses ocaml python test +thinlto xml video_cards_radeon"

COMMON_DEPEND="
	sys-libs/zlib:0=
	libedit? ( dev-libs/libedit:0=[${MULTILIB_USEDEP}] )
	libffi? ( >=virtual/libffi-3.0.13-r1:0=[${MULTILIB_USEDEP}] )
	ncurses? ( >=sys-libs/ncurses-5.9-r3:5=[${MULTILIB_USEDEP}] )
	ocaml? (
		>=dev-lang/ocaml-4.00.0:0=
		dev-ml/findlib
		dev-ml/ocaml-ctypes )"
# configparser-3.2 breaks the build (3.3 or none at all are fine)
DEPEND="${COMMON_DEPEND}
	dev-lang/perl
	>=sys-devel/make-3.81
	>=sys-devel/flex-2.5.4
	>=sys-devel/bison-1.875d
	|| ( >=sys-devel/gcc-3.0 >=sys-devel/llvm-3.5
		( >=sys-freebsd/freebsd-lib-9.1-r10 sys-libs/libcxx )
	)
	|| ( >=sys-devel/binutils-2.18 >=sys-devel/binutils-apple-5.1 )
	doc? ( dev-python/sphinx )
	libffi? ( virtual/pkgconfig )
	!!<dev-python/configparser-3.3.0.2
	ocaml? ( test? ( dev-ml/ounit ) )
	${PYTHON_DEPS}"
RDEPEND="${COMMON_DEPEND}
	abi_x86_32? ( !<=app-emulation/emul-linux-x86-baselibs-20130224-r2
		!app-emulation/emul-linux-x86-baselibs[-abi_x86_32(-)] )
	!<=sys-devel/lld-8.0_pre349610-r5"

# pypy gives me around 1700 unresolved tests due to open file limit
# being exceeded. probably GC does not close them fast enough.
REQUIRED_USE="
	${PYTHON_REQUIRED_USE}
	llvm_pgo_generate? ( !llvm_pgo_use )"

pkg_pretend() {
	# in megs
	# !clang !debug !multitarget -O2       400
	# !clang !debug  multitarget -O2       550
	#  clang !debug !multitarget -O2       950
	#  clang !debug  multitarget -O2      1200
	# !clang  debug  multitarget -O2      5G
	#  clang !debug  multitarget -O0 -g  12G
	#  clang  debug  multitarget -O2     16G
	#  clang  debug  multitarget -O0 -g  14G

	local build_size=550

	if use debug; then
		ewarn "USE=debug is known to increase the size of package considerably"
		ewarn "and cause the tests to fail."
		ewarn

		(( build_size *= 14 ))
	elif is-flagq '-g?(gdb)?([1-9])'; then
		ewarn "The C++ compiler -g option is known to increase the size of the package"
		ewarn "considerably. If you run out of space, please consider removing it."
		ewarn

		(( build_size *= 10 ))
	fi

	# Multiply by number of ABIs :).
	local abis=( $(multilib_get_enabled_abis) )
	(( build_size *= ${#abis[@]} ))

	local CHECKREQS_DISK_BUILD=${build_size}M
	check-reqs_pkg_pretend

	if [[ ${MERGE_TYPE} != binary ]]; then
		echo 'int main() {return 0;}' > "${T}"/test.cxx || die
		ebegin "Trying to build a C++11 test program"
		if ! $(tc-getCXX) -std=c++11 -o /dev/null "${T}"/test.cxx; then
			eerror "LLVM-${PV} requires C++11-capable C++ compiler. Your current compiler"
			eerror "does not seem to support -std=c++11 option. Please upgrade your compiler"
			eerror "to gcc-4.7 or an equivalent version supporting C++11."
			die "Currently active compiler does not support -std=c++11"
		fi
		eend ${?}
	fi
}

pkg_setup() {
	pkg_pretend
	export CMAKE_USE_DIR="${S}/llvm"
}

check_lld_works() {
	echo 'int main() {return 0;}' > "${T}"/lld.cxx || die
	echo "Trying to link program with lld"
	$(tc-getCXX) -fuse-ld=lld -std=c++11 -o /dev/null "${T}"/lld.cxx
}

apply_pgo_profile() {
	! use llvm-tot && ( \
		( use llvm-next && use llvm-next_pgo_use ) ||
		( ! use llvm-next && use llvm_pgo_use ) )
}

src_unpack() {
	local llvm_hash

	if use llvm-tot; then
		llvm_hash="origin/master"
	elif use llvm-next; then
		llvm_hash="${LLVM_NEXT_HASH}"
	else
		llvm_hash="${LLVM_HASH}"
	fi

	# Don't unpack profdata file when calling git-2_src_unpack.
	EGIT_NOUNPACK=1

	# Unpack llvm
	ESVN_PROJECT="llvm"
	EGIT_COMMIT="${llvm_hash}"
	git-2_src_unpack

	if apply_pgo_profile; then
		cd "${WORKDIR}"
		local profile_hash
		if use llvm-next; then
			profile_hash="${LLVM_NEXT_HASH}"
		else
			profile_hash="${LLVM_HASH}"
		fi
		unpack "llvm-profdata-${profile_hash}.tar.xz"
	fi
	EGIT_NOUNPACK=
}

pick_cherries() {
	local CHERRIES=""

	# clang
	# Next two for: crbug/977282
	CHERRIES+=" 7e48b406ef5ef2208c75874f7751a786e748706f" #r361885
	CHERRIES+=" 37b753368238cd25868632960f477d25f973b977" #r363548

	# llvm
	# Next two from google3 cherries for r361749
	CHERRIES+=" 8472fa6c54c9d044adcd147f6826bccebd730f30" #r362856
	CHERRIES+=" ca84c4be4b443df7e49202bb6ca42f831b524245" #r361781
	# crbug.com/916740.
	CHERRIES+=" 26cc5bcb1a392c9e352be35c50f18e1404d91159" #r364039
	# Next 3 for crbug/984116
	CHERRIES+=" 90ba54bf67c4c134d000b064121789a32c0c6a73" #r366369
	CHERRIES+=" 39fc2843e4eb07370d55f0a7a0db34d4bd6c9d5f" #r366370
	CHERRIES+=" 9f2b290addfc4d9f514790b47773b141682b0db5" #r366371

	# compiler-rt

	# lld

	for cherry in ${CHERRIES}; do
		epatch "${FILESDIR}/cherry/${cherry}.patch"
	done
}

pick_next_cherries() {
	local CHERRIES=""

	# clang

	# llvm
	# Next 3 for crbug/984116
	CHERRIES+=" 90ba54bf67c4c134d000b064121789a32c0c6a73" #r366369
	CHERRIES+=" 39fc2843e4eb07370d55f0a7a0db34d4bd6c9d5f" #r366370
	CHERRIES+=" 9f2b290addfc4d9f514790b47773b141682b0db5" #r366371

	# compiler-rt

	# lld
	CHERRIES+=" be8275753fe23fb56c4cb5127695dad540b9053c" #r365759
	CHERRIES+=" e1ee3837acfea876b279f7f00474fdabd5d76cb5" #r365760

	for cherry in ${CHERRIES}; do
		epatch "${FILESDIR}/cherry/${cherry}.patch"
	done
}

get_most_recent_revision() {
	local subdir="${S}/llvm"

	# Tries to parse the last revision ID present in the most recent commit
	# with a revision ID attached. We can't simply `grep -m 1`, since it's
	# reasonable for a revert message to include the git-svn-id of the
	# commit it's reverting.
	#
	# Thankfully, LLVM's machinery always makes this ID the last line of
	# each upstream commit, so we just need to search for it, with commit
	# two lines later.
	#
	# Example of revision ID line:
	# llvm-svn: 358929
	#
	# Where 358929 is the revision.
	git -C "${subdir}" log | \
		awk '
			/^commit/ {
				if (most_recent_id != "") {
					print most_recent_id
					exit
				}
			}
			/^\s+llvm-svn: [0-9]+$/ { most_recent_id = $2 }'
}

# This cache is a bit awkward, since the most natural way to do this is "make a
# get_most_recent_revision function, and call it in a subshell." Subshells make
# caching worthless. :)
most_recent_revision=

ensure_most_recent_revision_set() {
	if test -z "$most_recent_revision"; then
		most_recent_revision="$(get_most_recent_revision)"
	fi
}

epatch_between() {
	local min_revision="$1"
	local max_revision="$2"
	local patch="$3"

	ensure_most_recent_revision_set

	if test "$min_revision" -le "$most_recent_revision" -a \
			"$max_revision" -ge "$most_recent_revision"; then
		epatch "$patch"
	else
		einfo "Patch $3 not applied"
		return 1
	fi
}

epatch_after() {
	epatch_between $1 9999999 $2
}

epatch_before() {
	epatch_between 0 $1 $2
}

src_prepare() {
	if ! use llvm-tot ; then
		use llvm-next || pick_cherries
		use llvm-next && pick_next_cherries
	fi

	# compiler-rt patches
	epatch "${FILESDIR}"/llvm-next-leak-whitelist.patch
	epatch "${FILESDIR}"/clang-4.0-asan-default-path.patch
	epatch "${FILESDIR}"/compiler-rt-9.0-force-fPIC.patch

	# new pass manager patches
	# crbug/958867
	epatch "${FILESDIR}"/llvm-9.0-no-cgprofile.patch
	# https://bugs.llvm.org/show_bug.cgi?id=42272
	epatch "${FILESDIR}"/llvm-9.0-no-assert-domtree.patch

	# Make ocaml warnings non-fatal, bug #537308
	sed -e "/RUN/s/-warn-error A//" -i llvm/test/Bindings/OCaml/*ml  || die

	# llvm patches
	# Allow custom cmake build types (like 'Gentoo')
	epatch "${FILESDIR}"/cmake/${PN}-3.8-allow_custom_cmake_build_types.patch

	# crbug/591436
	epatch "${FILESDIR}"/llvm-8.0-clang-executable-detection.patch

	epatch "${FILESDIR}"/llvm-3.9-dwarf-version.patch

	# Revert r335145 and r335284 since android reverts them.
	# b/113573336
	epatch_after 335145 "${FILESDIR}"/llvm-8.0-revert-r335145.patch
	use llvm-next || epatch "${FILESDIR}"/clang-8.0-revert-r335284.patch
	use llvm-next && epatch "${FILESDIR}"/clang-next-9.0-revert-r335284.patch

	# clang patches
	# clang: crbug/606391
	epatch "${FILESDIR}"/${PN}-3.8-invocation.patch

	# lld patches
	# Allow .elf suffix in lld binary name.
	epatch "${FILESDIR}/lld-invoke-name.patch"
	# Put .text.hot section before .text section.
	use llvm-next || epatch "${FILESDIR}"/lld-9.0-reorder-hotsection-early.patch
	use llvm-next && epatch "${FILESDIR}"/lld-next-9.0-reorder-hotsection-early.patch

	# Fix LLD errors in duplicate symbols in version script. http://crbug.com/982882
	epatch_between 361749 365595 "${FILESDIR}"/lld-9.0-apply-r365759.patch

	# Fix LLD errors in handling non-glob patterns in version script. FIXME: Add bug link.
	epatch_between 361749 365595 "${FILESDIR}"/lld-9.0-apply-r365760.patch

	python_setup

	# User patches
	epatch_user

	# Native libdir is used to hold LLVMgold.so
	NATIVE_LIBDIR=$(get_libdir)
}

enable_asserts() {
	# keep asserts enabled for llvm-tot
	if use llvm-tot; then
		echo yes
	else
		usex debug
	fi
}

multilib_src_configure() {
	local targets
	if use multitarget; then
		targets='host;X86;ARM;AArch64;NVPTX'
	else
		targets='host;CppBackend'
		use video_cards_radeon && targets+=';AMDGPU'
	fi

	local ffi_cflags ffi_ldflags
	if use libffi; then
		ffi_cflags=$(pkg-config --cflags-only-I libffi)
		ffi_ldflags=$(pkg-config --libs-only-L libffi)
	fi

	local libdir=$(get_libdir)
	local mycmakeargs=(
		"${mycmakeargs[@]}"
		-DLLVM_ENABLE_PROJECTS="llvm;clang;lld;compiler-rt;clang-tools-extra"
		-DLLVM_LIBDIR_SUFFIX=${libdir#lib}

		-DLLVM_BUILD_LLVM_DYLIB=ON
		# Link LLVM statically
		-DLLVM_LINK_LLVM_DYLIB=OFF

		-DLLVM_ENABLE_TIMESTAMPS=OFF
		-DLLVM_TARGETS_TO_BUILD="${targets}"
		-DLLVM_BUILD_TESTS=$(usex test)

		-DLLVM_ENABLE_FFI=$(usex libffi)
		-DLLVM_ENABLE_TERMINFO=$(usex ncurses)
		-DLLVM_ENABLE_ASSERTIONS=$(enable_asserts)
		-DLLVM_ENABLE_EH=ON
		-DLLVM_ENABLE_RTTI=ON

		-DWITH_POLLY=OFF # TODO

		-DLLVM_HOST_TRIPLE="${CHOST}"

		-DFFI_INCLUDE_DIR="${ffi_cflags#-I}"
		-DFFI_LIBRARY_DIR="${ffi_ldflags#-L}"
		-DLLVM_BINUTILS_INCDIR="${SYSROOT}"/usr/include

		-DHAVE_HISTEDIT_H=$(usex libedit)
		-DENABLE_LINKER_BUILD_ID=ON
		-DCLANG_VENDOR="Chromium OS ${PVR}"
		# override default stdlib and rtlib
		-DCLANG_DEFAULT_CXX_STDLIB=$(usex default-libcxx libc++ "")
		-DCLANG_DEFAULT_RTLIB=$(usex default-compiler-rt compiler-rt "")

		# Turn on new pass manager for LLVM
		-DENABLE_EXPERIMENTAL_NEW_PASS_MANAGER=ON

		# crbug/855759
		-DCOMPILER_RT_BUILD_CRT=OFF

		-DCMAKE_POSITION_INDEPENDENT_CODE=ON
		-DCLANG_DEFAULT_UNWINDLIB=libgcc
	)

	# Update LLVM to 9.0 will cause LLVM to complain GCC
	# version is < 5.1. Add this flag to suppress the error.
	mycmakeargs+=(
		-DLLVM_TEMPORARILY_ALLOW_OLD_TOOLCHAIN=1
	)

	if check_lld_works; then
		mycmakeargs+=(
			# We use lld to link llvm, because:
			# 1) Gold has issue with no index for archive,
			# 2) Gold doesn't support instrumented compiler-rt well.
			-DLLVM_USE_LINKER=lld
		)
		# The standalone toolchain may be run at places not supporting
		# smallPIE, disabling it for lld.
		# Pass -fuse-ld=lld to make cmake happy.
		append-ldflags "-fuse-ld=lld -Wl,--pack-dyn-relocs=none"
		# Disable warning about profile not matching.
		append-flags "-Wno-backend-plugin"

		if use thinlto; then
			mycmakeargs+=(
				-DLLVM_ENABLE_LTO=thin
			)
		fi

		if apply_pgo_profile; then
			mycmakeargs+=(
				-DLLVM_PROFDATA_FILE="${WORKDIR}/llvm.profdata"
			)
		fi

		if use llvm_pgo_generate; then
			mycmakeargs+=(
				-DLLVM_BUILD_INSTRUMENTED=IR
			)
		fi
	fi

	if ! multilib_is_native_abi || ! use ocaml; then
		mycmakeargs+=(
			-DOCAMLFIND=NO
		)
	fi
#	Note: go bindings have no CMake rules at the moment
#	but let's kill the check in case they are introduced
#	if ! multilib_is_native_abi || ! use go; then
		mycmakeargs+=(
			-DGO_EXECUTABLE=GO_EXECUTABLE-NOTFOUND
		)
#	fi

	if multilib_is_native_abi; then
		mycmakeargs+=(
			-DLLVM_BUILD_DOCS=$(usex doc)
			-DLLVM_ENABLE_SPHINX=$(usex doc)
			-DLLVM_ENABLE_DOXYGEN=OFF
			-DLLVM_INSTALL_HTML="${EPREFIX}/usr/share/doc/${PF}/html"
			-DSPHINX_WARNINGS_AS_ERRORS=OFF
			-DLLVM_INSTALL_UTILS=ON
		)
	fi

	cmake-utils_src_configure
}

multilib_src_compile() {
	cmake-utils_src_compile
	# TODO: not sure why this target is not correctly called
	multilib_is_native_abi && use doc && use ocaml && cmake-utils_src_make docs/ocaml_doc

	pax-mark m "${BUILD_DIR}"/bin/llvm-rtdyld
	pax-mark m "${BUILD_DIR}"/bin/lli
	pax-mark m "${BUILD_DIR}"/bin/lli-child-target

	if use test; then
		pax-mark m "${BUILD_DIR}"/unittests/ExecutionEngine/Orc/OrcJITTests
		pax-mark m "${BUILD_DIR}"/unittests/ExecutionEngine/MCJIT/MCJITTests
		pax-mark m "${BUILD_DIR}"/unittests/Support/SupportTests
	fi
}

multilib_src_test() {
	# respect TMPDIR!
	local -x LIT_PRESERVES_TMP=1
	local test_targets=( check )
	cmake-utils_src_make "${test_targets[@]}"
}

src_install() {
	local MULTILIB_CHOST_TOOLS=(
		/usr/bin/llvm-config
	)

	local MULTILIB_WRAPPED_HEADERS=(
		/usr/include/llvm/Config/config.h
		/usr/include/llvm/Config/llvm-config.h
	)

	multilib-minimal_src_install
}

multilib_src_install() {
	cmake-utils_src_install

	local wrapper_script=clang_host_wrapper
	cat "${FILESDIR}/clang_host_wrapper.header" \
		"${FILESDIR}/wrapper_script_common" \
		"${FILESDIR}/clang_host_wrapper.body" > \
		"${D}/usr/bin/${wrapper_script}" || die
	chmod 755 "${D}/usr/bin/${wrapper_script}" || die
	newbin "${D}/usr/bin/clang-tidy" "clang-tidy"
	dobin "${FILESDIR}/bisect_driver.py"
	exeinto "/usr/bin"
	dosym "${wrapper_script}" "/usr/bin/${CHOST}-clang"
	dosym "${wrapper_script}" "/usr/bin/${CHOST}-clang++"
	mv "${D}/usr/bin/lld" "${D}/usr/bin/lld.real" || die
	newexe "${FILESDIR}/ldwrapper" "lld" || die
}

multilib_src_install_all() {
	insinto /usr/share/vim/vimfiles
	doins -r llvm/utils/vim/*/.
	# some users may find it useful
	dodoc llvm/utils/vim/vimrc
	dobin "${S}/compiler-rt/lib/asan/scripts/asan_symbolize.py"
}
