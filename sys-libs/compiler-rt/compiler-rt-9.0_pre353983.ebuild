# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils toolchain-funcs cros-constants cmake-utils git-2 cros-llvm

EGIT_REPO_URI="${CROS_GIT_HOST_URL}/external/github.com/llvm/llvm-project"

# llvm:353983 https://critique.corp.google.com/#review/233864070
export EGIT_COMMIT="de7a0a152648d1a74cf4319920b1848aa00d1ca3" # r353983

DESCRIPTION="Compiler runtime library for clang"
HOMEPAGE="http://compiler-rt.llvm.org/"

LICENSE="UoI-NCSA"
SLOT="0"
KEYWORDS="*"
IUSE="llvm-next"
DEPEND="sys-devel/llvm"
if [[ ${CATEGORY} == cross-* ]] ; then
	DEPEND+="
		${CATEGORY}/binutils
		${CATEGORY}/gcc
		"
fi

pkg_setup() {
	export CMAKE_USE_DIR="${S}/compiler-rt"
}

src_unpack() {
	if use llvm-next; then
		# llvm:353983 https://critique.corp.google.com/#review/233864070
		export EGIT_COMMIT="de7a0a152648d1a74cf4319920b1848aa00d1ca3" # r353983
	fi
	git-2_src_unpack
}

src_prepare() {
	# Cherry-picks
	local CHERRIES=""
	if use llvm-next; then
		CHERRIES=""
	else
		CHERRIES=""
	fi
	# Cherry-pick for both llvm and llvm-next
	CHERRIES+=" a2062b222d93e2ae86d36ec75923c8b1e4ae0d81" #r354632
	CHERRIES+=" e3b6d11038f3927fd02ec6d5459cfd0ffbe6b2fe" #r354989, needed to pick r355030
	CHERRIES+=" f46a52b5363d22bba6cc6081da295ece181977f2" #r355030
	CHERRIES+=" f6b0a14bff33f85087e9cc5c3b1bb00f58ed8b8b" #r355041
	CHERRIES+=" d4b4e17d2c70c8d498ad33422cf847d659b5b0cf" #r355064
	CHERRIES+=" 37ce064082c6c8283829f206af55ff6a28e95544" #r355125
	CHERRIES+=" 86724e40bfa544a5024a2a3d522934aef6914cc7" #r356581

	for cherry in ${CHERRIES}; do
		epatch "${FILESDIR}/cherry/${cherry}.patch"
	done

	# Apply patches
	epatch "${FILESDIR}"/llvm-next-leak-whitelist.patch
	epatch "${FILESDIR}"/clang-4.0-asan-default-path.patch
}

src_configure() {
	setup_cross_toolchain
	# Need libgcc for bootstrapping.
	append-flags "-rtlib=libgcc"
	# Compiler-rt libraries need to be built before libc++ when
	# libc++ is default in clang.
	# Compiler-rt builtins are C only.
	# Even though building compiler-rt libraries does not require C++ compiler,
	# CMake does not like a non-working C++ compiler.
	# Avoid CMake complains about non-working C++ compiler
	# by using libstdc++ since libc++ is built after compiler-rt in crossdev.
	append-cxxflags "-stdlib=libstdc++"
	append-flags "-fomit-frame-pointer"
	if [[ ${CTARGET} == armv7a* ]]; then
		# Use vfpv3 to be able to target non-neon targets
		append-flags -mfpu=vfpv3
	elif [[ ${CTARGET} == armv7m* ]]; then
		# Some of the arm32 assembly builtins in compiler-rt need vfpv2.
		# Passing this flag should not be required but currently
		# upstream compiler-rt's cmake config does not provide a way to
		# exclude these asm files.
		append-flags -Wa,-mfpu=vfpv2
	fi
	BUILD_DIR=${WORKDIR}/${P}_build

	local mycmakeargs=(
		-DLLVM_ENABLE_PROJECTS="compiler-rt"
	)

	if [[ ${CTARGET} == *-eabi ]]; then
		mycmakeargs+=(
			-DCMAKE_TRY_COMPILE_TARGET_TYPE=STATIC_LIBRARY
			-DCOMPILER_RT_OS_DIR=baremetal
			-DCOMPILER_RT_BAREMETAL_BUILD=yes
			-DCMAKE_C_COMPILER_TARGET="${CTARGET}"
			-DCOMPILER_RT_DEFAULT_TARGET_ONLY=yes
		)
	else
		mycmakeargs+=(
			-DCOMPILER_RT_TEST_TARGET_TRIPLE="${CTARGET}"
		)
	fi
	mycmakeargs+=(
		-DCOMPILER_RT_INSTALL_PATH="${EPREFIX}$(${CC} --print-resource-dir)"
	)
	cmake-utils_src_configure
}

src_install() {
	# There is install conflict between cross-armv7a-cros-linux-gnueabihf
	# and cross-armv7a-cros-linux-gnueabi. Remove this once we are ready to
	# move to cross-armv7a-cros-linux-gnueabihf.
	if [[ ${CTARGET} == armv7a-cros-linux-gnueabi ]] ; then
		return
	fi
	cmake-utils_src_install

	# includes and docs are installed for all sanitizers and xray
	# These files conflict with files provided in llvm ebuild
	local libdir=$(llvm-config --libdir)
	rm -rf "${ED}"usr/share || die
	rm -rf "${ED}"${libdir}/clang/*/include || die
	rm -f "${ED}"${libdir}/clang/*/*_blacklist.txt || die
	rm -f "${ED}"${libdir}/clang/*/*/*_blacklist.txt || die
	rm -f "${ED}"${libdir}/clang/*/dfsan_abilist.txt || die
	rm -f "${ED}"${libdir}/clang/*/*/dfsan_abilist.txt || die

	# Copy compiler-rt files to a new clang version to handle llvm updates gracefully.
	local llvm_version=$(llvm-config --version)
	local clang_version=${llvm_version%svn*}
	clang_version=${clang_version%git*}
	if [[ ${clang_version} == "8.0.0" ]] ; then
		new_version="9.0.0"
	else
		new_version="8.0.0"
	fi
	cp -r  "${D}${libdir}/clang/${clang_version}" "${D}${libdir}/clang/${new_version}"
}
