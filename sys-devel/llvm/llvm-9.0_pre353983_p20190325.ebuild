# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

: ${CMAKE_MAKEFILE_GENERATOR:=ninja}
PYTHON_COMPAT=( python2_7 )

inherit  cros-constants check-reqs cmake-utils eutils flag-o-matic git-2 git-r3 \
	multilib multilib-minimal python-single-r1 toolchain-funcs pax-utils

# llvm:353983 https://critique.corp.google.com/#review/233864070
LLVM_HASH="de7a0a152648d1a74cf4319920b1848aa00d1ca3" # EGIT_COMMIT r353983
# llvm:353983 https://critique.corp.google.com/#review/233864070
LLVM_NEXT_HASH="de7a0a152648d1a74cf4319920b1848aa00d1ca3" # EGIT_COMMIT r353983

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

	# llvm
	CHERRIES+=" d0b1f30b32bda78267a48f1812adabcfe872fe43" #r354062
	CHERRIES+=" 74b874ac4c6c079f85edd1f2957b1d96e0127ea5" #r356988

	# compiler-rt
	CHERRIES+=" a2062b222d93e2ae86d36ec75923c8b1e4ae0d81" #r354632
	CHERRIES+=" e3b6d11038f3927fd02ec6d5459cfd0ffbe6b2fe" #r354989, needed to pick r355030
	CHERRIES+=" f46a52b5363d22bba6cc6081da295ece181977f2" #r355030
	CHERRIES+=" f6b0a14bff33f85087e9cc5c3b1bb00f58ed8b8b" #r355041
	CHERRIES+=" d4b4e17d2c70c8d498ad33422cf847d659b5b0cf" #r355064
	CHERRIES+=" 37ce064082c6c8283829f206af55ff6a28e95544" #r355125
	CHERRIES+=" 86724e40bfa544a5024a2a3d522934aef6914cc7" #r356581

	# lld
	CHERRIES+=" 432030e843bf124b4d285874362b6fd00446dd56" #r357133
	CHERRIES+=" 3ce9af9370d091b7d959902216482f3015e965fc" #r357160

	for cherry in ${CHERRIES}; do
		epatch "${FILESDIR}/cherry/${cherry}.patch"
	done
}

pick_next_cherries() {
	local CHERRIES=""

	# clang

	# llvm
	CHERRIES+=" d0b1f30b32bda78267a48f1812adabcfe872fe43" #r354062
	CHERRIES+=" 74b874ac4c6c079f85edd1f2957b1d96e0127ea5" #r356988

	# compiler-rt
	CHERRIES+=" a2062b222d93e2ae86d36ec75923c8b1e4ae0d81" #r354632
	CHERRIES+=" e3b6d11038f3927fd02ec6d5459cfd0ffbe6b2fe" #r354989, needed to pick r355030
	CHERRIES+=" f46a52b5363d22bba6cc6081da295ece181977f2" #r355030
	CHERRIES+=" f6b0a14bff33f85087e9cc5c3b1bb00f58ed8b8b" #r355041
	CHERRIES+=" d4b4e17d2c70c8d498ad33422cf847d659b5b0cf" #r355064
	CHERRIES+=" 37ce064082c6c8283829f206af55ff6a28e95544" #r355125
	CHERRIES+=" 86724e40bfa544a5024a2a3d522934aef6914cc7" #r356581

	#lld
	CHERRIES+=" 432030e843bf124b4d285874362b6fd00446dd56" #r357133
	CHERRIES+=" 3ce9af9370d091b7d959902216482f3015e965fc" #r357160

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

	# Make ocaml warnings non-fatal, bug #537308
	sed -e "/RUN/s/-warn-error A//" -i llvm/test/Bindings/OCaml/*ml  || die

	# llvm patches
	# Allow custom cmake build types (like 'Gentoo')
	epatch "${FILESDIR}"/cmake/${PN}-3.8-allow_custom_cmake_build_types.patch

	# crbug/591436
	epatch "${FILESDIR}"/llvm-8.0-clang-executable-detection.patch

	epatch "${FILESDIR}"/llvm-3.9-dwarf-version.patch

	# Temporarily revert r332058 as it caused speedometer2 perf regression.
	# https://crbug.com/864781
	epatch_after 332058 "${FILESDIR}"/llvm-8.0-next-revert-afdo-hotness.patch

	# Revert r335145 and r335284 since android reverts them.
	# b/113573336
	epatch_after 335145 "${FILESDIR}"/llvm-8.0-revert-r335145.patch

	# clang patches
	# clang: crbug/606391
	epatch "${FILESDIR}"/${PN}-3.8-invocation.patch

	# Link libgcc_eh when using compiler-rt as default rtlib.
	# https://llvm.org/bugs/show_bug.cgi?id=28681
	epatch "${FILESDIR}"/clang-6.0-enable-libgcc-with-compiler-rt.patch

	epatch "${FILESDIR}"/clang-next-8.0-revert-r335284.patch

	# revert r340839, https://crbug.com/916740
	epatch "${FILESDIR}"/llvm-8.0-revert-asm-debug-info.patch

	# lld patches
	# These 2 patches are still reverted in Android.
	epatch "${FILESDIR}"/lld-8.0-revert-r326242.patch
	epatch "${FILESDIR}"/lld-8.0-revert-r325849.patch
	# Allow .elf suffix in lld binary name.
	epatch "${FILESDIR}/lld-invoke-name.patch"
	# Put .text.hot section before .text section.
	epatch "${FILESDIR}"/lld-8.0-reorder-hotsection-early.patch

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
