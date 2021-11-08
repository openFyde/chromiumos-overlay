# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

CROS_WORKON_REPO="${CROS_GIT_HOST_URL}"
CROS_WORKON_PROJECT="external/github.com/llvm/llvm-project"
CROS_WORKON_LOCALNAME="llvm-project"
CROS_WORKON_MANUAL_UPREV=1

inherit eutils toolchain-funcs cros-constants cmake-utils git-2 cros-llvm cros-workon

EGIT_REPO_URI="${CROS_GIT_HOST_URL}/external/github.com/llvm/llvm-project
	${CROS_GIT_HOST_URL}/external/github.com/llvm/llvm-project"
EGIT_BRANCH=main

LLVM_HASH="282c83c32384cb2f37030c28650fef4150a8b67c" # r450784
LLVM_NEXT_HASH="282c83c32384cb2f37030c28650fef4150a8b67c" # r450784

DESCRIPTION="Compiler runtime library for clang"
HOMEPAGE="http://compiler-rt.llvm.org/"

LICENSE="UoI-NCSA"
SLOT="0"
KEYWORDS="*"
if [[ "${PV}" == "9999" ]]; then
	KEYWORDS="~*"
fi
IUSE="+llvm-crt llvm-next llvm-tot"
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
	if use llvm-next || use llvm-tot; then
		export EGIT_COMMIT="${LLVM_NEXT_HASH}"
	else
		export EGIT_COMMIT="${LLVM_HASH}"
	fi
	if [[ "${PV}" != "9999" ]]; then
		CROS_WORKON_COMMIT="${EGIT_COMMIT}"
	fi
	cros-workon_src_unpack
}

src_prepare() {
	"${FILESDIR}"/patch_manager/patch_manager.py \
		--svn_version "$(get_most_recent_revision)" \
		--patch_metadata_file "${FILESDIR}"/PATCHES.json \
		--filesdir_path "${FILESDIR}" \
		--src_path "${S}" || die
	eapply_user
}

src_configure() {
	setup_cross_toolchain
	append-flags "-fomit-frame-pointer"
	# CTARGET is defined in an eclass, which shellcheck won't see
	# shellcheck disable=SC2154
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
		"-DLLVM_ENABLE_PROJECTS=compiler-rt"
		"-DCMAKE_TRY_COMPILE_TARGET_TYPE=STATIC_LIBRARY"
		# crbug/855759
		"-DCOMPILER_RT_BUILD_CRT=$(usex llvm-crt)"
		"-DCOMPILER_RT_USE_LIBCXX=yes"
		"-DCOMPILER_RT_LIBCXXABI_PATH=${S}/libcxxabi"
		"-DCOMPILER_RT_LIBCXX_PATH=${S}/libcxx"
		"-DCOMPILER_RT_HAS_GNU_VERSION_SCRIPT_COMPAT=no"
		"-DCOMPILER_RT_BUILTINS_HIDE_SYMBOLS=OFF"
		"-DCOMPILER_RT_SANITIZERS_TO_BUILD=asan;msan;hwasan;tsan;cfi;ubsan_minimal;gwp_asan"
		# b/200831212: Disable per runtime install dirs.
		"-DLLVM_ENABLE_PER_TARGET_RUNTIME_DIR=OFF"
		# b/204220308: Disable OCR since we are not using it.
		"-DCOMPILER_RT_BUILD_ORC=OFF"
		"-DCOMPILER_RT_INSTALL_PATH=${EPREFIX}$(${CC} --print-resource-dir)"
	)

	if [[ ${CTARGET} == *-eabi ]]; then
		# Options for baremetal toolchains e.g. armv7m-cros-eabi.
		mycmakeargs+=(
			"-DCOMPILER_RT_OS_DIR=baremetal"
			"-DCOMPILER_RT_BAREMETAL_BUILD=yes"
			"-DCMAKE_C_COMPILER_TARGET=${CTARGET}"
			"-DCOMPILER_RT_DEFAULT_TARGET_ONLY=yes"
			"-DCOMPILER_RT_BUILD_SANITIZERS=no"
			"-DCOMPILER_RT_BUILD_LIBFUZZER=no"
		)
		# b/205342596: This is a hack to provide armv6m builtins for use with
		# arm-none-eabi without creating a separate armv6m toolchain.
		if [[ ${CTARGET} == arm-none-eabi ]]; then
			append-flags "-march=armv6m --sysroot=/usr/arm-none-eabi"
			mycmakeargs+=( "-DCMAKE_C_COMPILER_TARGET=armv6m-none-eabi" )
		fi
	else
		# Standard userspace toolchains e.g. armv7a-cros-linux-gnueabihf.
		mycmakeargs+=(
			"-DCOMPILER_RT_DEFAULT_TARGET_TRIPLE=${CTARGET}"
			"-DCOMPILER_RT_TEST_TARGET_TRIPLE=${CTARGET}"
			"-DCOMPILER_RT_BUILD_LIBFUZZER=yes"
			"-DCOMPILER_RT_BUILD_SANITIZERS=yes"
		)
	fi
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
	rm -rf "${ED}${libdir}"/clang/*/include || die
	rm -f "${ED}${libdir}"/clang/*/*list.txt || die
	rm -f "${ED}${libdir}"/clang/*/*/*list.txt || die
	rm -f "${ED}${libdir}"/clang/*/dfsan_abilist.txt || die
	rm -f "${ED}${libdir}"/clang/*/*/dfsan_abilist.txt || die
	rm -f "${ED}${libdir}"/clang/*/bin/* || die

	# Copy compiler-rt files to a new clang version to handle llvm updates gracefully.
	local llvm_version=$(llvm-config --version)
	local clang_version=${llvm_version%svn*}
	clang_version=${clang_version%git*}
	local compiler_rt_version=${clang_version%%.*}
	new_version="$((compiler_rt_version + 1)).0.0"
	old_version="$((compiler_rt_version - 1)).0.0"
	cp -r  "${D}${libdir}/clang/${clang_version}" "${D}${libdir}/clang/${new_version}"
	cp -r  "${D}${libdir}/clang/${clang_version}" "${D}${libdir}/clang/${old_version}"
}
