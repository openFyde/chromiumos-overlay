# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils toolchain-funcs cros-constants cmake-utils git-2 cros-llvm

EGIT_REPO_URI=${CROS_GIT_HOST_URL}/chromiumos/third_party/compiler-rt.git

# llvm:353983 https://critique.corp.google.com/#review/233864070
export EGIT_COMMIT="00d38a06e40df0bb8fbc1d3e4e6a3cc35bddbd74" # r353947

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

src_unpack() {
	if use llvm-next; then
		# llvm:353983 https://critique.corp.google.com/#review/233864070
		export EGIT_COMMIT="00d38a06e40df0bb8fbc1d3e4e6a3cc35bddbd74" # r353947
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
	CHERRIES+=" f5c0c1f1e1abe66650443d39f34fc205c2bc3175" #r354632
	CHERRIES+=" 4efb43207cb1f36870a79350d870ae47717af755" #r354989, needed to pick r355030
	CHERRIES+=" 9cde2249660f19f4ffa6d7703cecfdced27f9917" #r355030
	CHERRIES+=" 0679ae46f0e5a214dec9cab55ee7ffba159feb84" #r355041
	CHERRIES+=" 599d8c50c575e3e4cd774a7fc5636df87b493388" #r355064
	CHERRIES+=" 0f079fab83fb2af94e2fe9e4e44e8f47661a7ded" #r355125
	CHERRIES+=" 989c04edf69498e21866346d7dfa3b4c11e3c157" #r356581

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

	local mycmakeargs=()
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
