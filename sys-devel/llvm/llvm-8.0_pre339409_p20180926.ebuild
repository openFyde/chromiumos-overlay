# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

: ${CMAKE_MAKEFILE_GENERATOR:=ninja}
PYTHON_COMPAT=( python2_7 )

inherit  cros-constants check-reqs cmake-utils eutils flag-o-matic git-2 git-r3 \
	multilib multilib-minimal python-single-r1 toolchain-funcs pax-utils

DESCRIPTION="Low Level Virtual Machine"
HOMEPAGE="http://llvm.org/"
SRC_URI=""
EGIT_REPO_URI="http://llvm.org/git/llvm.git
	https://github.com/llvm-mirror/llvm.git"

LICENSE="UoI-NCSA"
SLOT="${PV%%.*}"
KEYWORDS="-* amd64"
IUSE="debug +default-compiler-rt +default-libcxx doc libedit +libffi multitarget
	ncurses ocaml python llvm-next llvm-tot test xml video_cards_radeon"

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
		!app-emulation/emul-linux-x86-baselibs[-abi_x86_32(-)] )"

# pypy gives me around 1700 unresolved tests due to open file limit
# being exceeded. probably GC does not close them fast enough.
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

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
}

src_unpack() {
	local clang_hash clang_tidy_hash compiler_rt_hash llvm_hash

	if use llvm-tot; then
		clang_hash="origin/master"
		clang_tidy_hash="origin/master"
		compiler_rt_hash="origin/master"
		llvm_hash="origin/master"
	elif use llvm-next; then
		# llvm:r339409 https://critique.corp.google.com/#review/199724125
		clang_hash="6601c8f525499269dba75f75bbd1ee2671aaa262" # EGIT_COMMIT r339409
		clang_tidy_hash="a32ea61ae09dc772fd7f688a89a0bd07c1bcc4f1" # EGIT_COMMIT r339401
		compiler_rt_hash="4f7c361dfbe533e883737844251598152333f087" # EGIT_COMMIT r339408
		llvm_hash="36f54002c931a026f490f9fb074c11d91e3487a2" # EGIT_COMMIT r339407
	else
		# llvm:r339409 https://critique.corp.google.com/#review/199724125
		clang_hash="6601c8f525499269dba75f75bbd1ee2671aaa262" # EGIT_COMMIT r339409
		clang_tidy_hash="a32ea61ae09dc772fd7f688a89a0bd07c1bcc4f1" # EGIT_COMMIT r339401
		compiler_rt_hash="4f7c361dfbe533e883737844251598152333f087" # EGIT_COMMIT r339408
		llvm_hash="36f54002c931a026f490f9fb074c11d91e3487a2" # EGIT_COMMIT r339407
	fi

	# non-local
	EGIT_REPO_URIS=(
		"llvm"
			""
			"${CROS_GIT_HOST_URL}/chromiumos/third_party/llvm.git"
			"$llvm_hash"
		"compiler-rt"
			"projects/compiler-rt"
			"${CROS_GIT_HOST_URL}/chromiumos/third_party/compiler-rt.git"
			"$compiler_rt_hash"
		"clang"
			"tools/clang"
			"${CROS_GIT_HOST_URL}/chromiumos/third_party/clang.git"
			"$clang_hash"
		"clang-tidy"
			"tools/clang/tools/extra"
			"${CROS_GIT_HOST_URL}/chromiumos/third_party/llvm-clang-tools-extra.git"
			"$clang_tidy_hash"
	)

	set -- "${EGIT_REPO_URIS[@]}"
		while [[ $# -gt 0 ]]; do
			ESVN_PROJECT=$1 \
			EGIT_SOURCEDIR="${S}/$2" \
			EGIT_REPO_URI=$3 \
			EGIT_COMMIT=$4 \
			git-2_src_unpack
			shift 4
		done
}

pick_cherries() {
	# clang
	local CHERRIES=""
	CHERRIES+=" 24c973171788bbd2699e267a69aad6e24f26ac24" # r340101
	CHERRIES+=" ca6d65812f8d6ba6093d0ea0d0bfd9cac518789d" # r342100
	CHERRIES+=" 260dbbf3855227c827be14b15cac86126f1d22fe" # r342990
	pushd "${S}"/tools/clang >/dev/null || die
	for cherry in ${CHERRIES}; do
		epatch "${FILESDIR}/cherry/${cherry}.patch"
	done
	popd >/dev/null || die

	# llvm
	CHERRIES=""
	CHERRIES+=" 3e5777f3b95e846530d70ed76577abca1be4f5f5" # r339411
	CHERRIES+=" 77a17afc92d543811e0f4f7913d4424aa630c117" # r340610
	CHERRIES+=" ddf089299bbfec8b94a61ffd83b2360e061dc108" # r340642
	CHERRIES+=" a4da437c1dec3fec9cf24e5d4b40bc77c2a6cec2" # r340654
	CHERRIES+=" b9c9629e618b883df7f03dc92f0d23eeca38693f" # r341512
	CHERRIES+=" 42eb082d63383b17c395e033e0095076efe4cb5e" # r341593
	CHERRIES+=" 906fd9ab476d0fa9e221bec32009eac3f3af5c60" # r341706
	CHERRIES+=" 75dc9f32d0b4f441d2e1b980445e9b7d2d74505c" # r342824
	pushd "${S}" >/dev/null || die
	for cherry in ${CHERRIES}; do
		epatch "${FILESDIR}/cherry/${cherry}.patch"
	done
	popd >/dev/null || die

	# compiler-rt
	CHERRIES=""
	CHERRIES+=" 2de6c3ce4d95b84ebd01ee22cacb27064213b4e1" #r340758
	pushd "${S}"/projects/compiler-rt >/dev/null || die
	for cherry in ${CHERRIES}; do
		epatch "${FILESDIR}/cherry/${cherry}.patch" 
	done
	popd >/dev/null || die
}

pick_next_cherries() {
	# clang
	local CHERRIES=""
	CHERRIES+=" 24c973171788bbd2699e267a69aad6e24f26ac24" # r340101
	CHERRIES+=" ca6d65812f8d6ba6093d0ea0d0bfd9cac518789d" # r342100
	CHERRIES+=" 260dbbf3855227c827be14b15cac86126f1d22fe" # r342990
	pushd "${S}"/tools/clang >/dev/null || die
	for cherry in ${CHERRIES}; do
		epatch "${FILESDIR}/cherry/${cherry}.patch"
	done
	popd >/dev/null || die

	# llvm
	CHERRIES=""
	CHERRIES+=" 3e5777f3b95e846530d70ed76577abca1be4f5f5" # r339411
	CHERRIES+=" 77a17afc92d543811e0f4f7913d4424aa630c117" # r340610
	CHERRIES+=" ddf089299bbfec8b94a61ffd83b2360e061dc108" # r340642
	CHERRIES+=" a4da437c1dec3fec9cf24e5d4b40bc77c2a6cec2" # r340654
	CHERRIES+=" b9c9629e618b883df7f03dc92f0d23eeca38693f" # r341512
	CHERRIES+=" 42eb082d63383b17c395e033e0095076efe4cb5e" # r341593
	CHERRIES+=" 906fd9ab476d0fa9e221bec32009eac3f3af5c60" # r341706
	CHERRIES+=" 75dc9f32d0b4f441d2e1b980445e9b7d2d74505c" # r342824
	pushd "${S}" >/dev/null || die
	for cherry in ${CHERRIES}; do
		epatch "${FILESDIR}/cherry/${cherry}.patch"
	done
	popd >/dev/null || die

	# compiler-rt
	CHERRIES=""
	CHERRIES+=" 2de6c3ce4d95b84ebd01ee22cacb27064213b4e1" #r340758
	pushd "${S}"/projects/compiler-rt >/dev/null || die
	for cherry in ${CHERRIES}; do
		epatch "${FILESDIR}/cherry/${cherry}.patch" 
	done
	popd >/dev/null || die
}

get_most_recent_revision_for_dir() {
	local subdir="$1"

	# Tries to parse the last git-svn-id present in the most recent commit
	# with a git-svn-id attached. We can't simply `grep -m 1 git-svn-id`,
	# since it's reasonable for a revert message to include the git-svn-id
	# of the commit it's reverting.
	#
	# Thankfully, LLVM's machinery always makes this git-svn-id the last
	# line of each upstream commit, so we just need to search for
	# /git-svn-id/, with /^commit/ two lines later.
	#
	# Example of git-svn-id line:
	# git-svn-id: https://llvm.org/svn/llvm-project/llvm/trunk@344884 [etc]
	#
	# Where:
	#   - The URL isn't the same across clang, llvm, compiler-rt, etc.
	#   - The revision is r344884
	#   - [etc] is trailing stuff we don't need to care about.
	git -C "$subdir" log | \
		sed -En ':x
			/^\s+git-svn-id:/!b
			h
			n
			/^$/!bx
			n
			/^commit/!bx
			g
			s/[^@]+@([0-9]+) .*/\1/
			p
			q'
}

get_uncached_most_recent_revision() {
	set -- "${EGIT_REPO_URIS[@]}"
	local max=0
	while [[ $# -gt 0 ]]; do
		local dir_name="${S}/$2"
		local subdir_rev=$(get_most_recent_revision_for_dir "$dir_name")

		if test "$max" -lt "$subdir_rev"; then
			max="$subdir_rev"
		fi
		shift 4
	done

	echo "$max"
}

# This cache is a bit awkward, since the most natural way to do this is "make a
# get_most_recent_revision function, and call it in a subshell." Subshells make
# caching worthless. :)
most_recent_revision=

ensure_most_recent_revision_set() {
	if test -z "$most_recent_revision"; then
		most_recent_revision="$(get_uncached_most_recent_revision)"
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
	epatch "${FILESDIR}"/llvm-6.0-gnueabihf.patch
	epatch "${FILESDIR}"/llvm-next-leak-whitelist.patch
	epatch "${FILESDIR}"/clang-4.0-asan-default-path.patch

	# Make ocaml warnings non-fatal, bug #537308
	sed -e "/RUN/s/-warn-error A//" -i test/Bindings/OCaml/*ml  || die

	# Allow custom cmake build types (like 'Gentoo')
	epatch "${FILESDIR}"/cmake/${PN}-3.8-allow_custom_cmake_build_types.patch

	# crbug/591436
	epatch "${FILESDIR}"/clang-executable-detection.patch

	# crbug/606391
	epatch "${FILESDIR}"/${PN}-3.8-invocation.patch

	epatch "${FILESDIR}"/llvm-3.9-dwarf-version.patch

	# Link libgcc_eh when using compiler-rt as default rtlib.
	# https://llvm.org/bugs/show_bug.cgi?id=28681
	epatch "${FILESDIR}"/clang-6.0-enable-libgcc-with-compiler-rt.patch

	# Temporarily revert r332058 as it caused speedometer2 perf regression.
	# https://crbug.com/864781

	epatch_after 332058 "${FILESDIR}"/llvm-next-revert-afdo-hotness.patch

	# Revert r328973 and r335145
	epatch_after 328973 "${FILESDIR}"/llvm-8.0-revert-r328973.patch
	epatch_after 335145 "${FILESDIR}"/llvm-8.0-revert-r335145.patch
	# Revert r335284, in clang
	pushd "${S}"/tools/clang >/dev/null || die
	epatch "${FILESDIR}"/clang-8.0-revert-r335284.patch
	popd >/dev/null || die

	python_setup

	# User patches
	epatch_user

	# Native libdir is used to hold LLVMgold.so
	NATIVE_LIBDIR=$(get_libdir)
}

enable_asserts() {
	# Enable assertions for llvm-next build
	if use llvm-next || use llvm-tot; then
		echo yes
	else
		usex debug
	fi
}

multilib_src_configure() {
	local targets
	if use multitarget; then
		targets=all
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
		-DLLVM_LIBDIR_SUFFIX=${libdir#lib}

		-DLLVM_BUILD_LLVM_DYLIB=ON
		-DLLVM_LINK_LLVM_DYLIB=ON
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
	dobin "${FILESDIR}/clang-tidy-parse-build-log.py"
	dobin "${FILESDIR}/clang-tidy-warn.py"
	dobin "${FILESDIR}/clang_tidy_execute.py"
	exeinto "/usr/bin"
	dosym "${wrapper_script}" "/usr/bin/${CHOST}-clang"
	dosym "${wrapper_script}" "/usr/bin/${CHOST}-clang++"
}

multilib_src_install_all() {
	insinto /usr/share/vim/vimfiles
	doins -r utils/vim/*/.
	# some users may find it useful
	dodoc utils/vim/vimrc
	dobin "${S}/projects/compiler-rt/lib/asan/scripts/asan_symbolize.py"
}
