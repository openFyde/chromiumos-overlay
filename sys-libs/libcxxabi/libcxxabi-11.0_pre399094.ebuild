# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

: ${CMAKE_MAKEFILE_GENERATOR:=ninja}
PYTHON_COMPAT=( python3_6 )

inherit cmake-multilib cros-constants cros-llvm flag-o-matic git-2 llvm python-any-r1

DESCRIPTION="Low level support for a standard C++ library"
HOMEPAGE="http://libcxxabi.llvm.org/"

SRC_URI=""
EGIT_REPO_URI="${CROS_GIT_HOST_URL}/external/github.com/llvm/llvm-project
	${CROS_GIT_HOST_URL}/external/github.com/llvm/llvm-project"

LLVM_HASH="83080a294ad7d145d758821bcf4354ad0cb7d299" # r399094
LLVM_NEXT_HASH="2dd9a4d855f6a6d3e84dd4d1e489e6265d206732" # r404259

LICENSE="|| ( UoI-NCSA MIT )"
SLOT="0"
KEYWORDS="*"
IUSE="+compiler-rt cros_host libunwind msan llvm-next llvm-tot +static-libs"

RDEPEND="
	libunwind? (
			|| (
				>=${CATEGORY}/libunwind-1[static-libs?,${MULTILIB_USEDEP}]
				>=${CATEGORY}/llvm-libunwind-3.9.0-r1[static-libs?,${MULTILIB_USEDEP}]
			)
	)
	!cros_host? ( sys-libs/gcc-libs )"

DEPEND="${RDEPEND}
	cros_host? ( sys-devel/llvm )"

python_check_deps() {
	has_version "dev-python/lit[${PYTHON_USEDEP}]"
}

pkg_setup() {
	setup_cross_toolchain
	llvm_pkg_setup
	export CMAKE_USE_DIR="${S}/libcxxabi"
}

src_unpack() {
	if use llvm-next || use llvm-tot; then
		export EGIT_COMMIT="${LLVM_NEXT_HASH}"
	else
		export EGIT_COMMIT="${LLVM_HASH}"
	fi
	git-2_src_unpack
}

src_prepare() {
	"${FILESDIR}"/patch_manager/patch_manager.py \
		--svn_version "$(get_most_recent_revision)" \
		--patch_metadata_file "${FILESDIR}"/PATCHES.json \
		--filesdir_path "${FILESDIR}" \
		--src_path "${S}" || die

	eapply_user
}

multilib_src_configure() {
	# Filter sanitzers flags.
	filter_sanitizers
	# Use vpfv3 fpu to be able to target non-neon targets.
	if [[ $(tc-arch) == "arm" ]] ; then
		append-flags -mfpu=vfpv3
	fi
	append-flags -I"${S}/libunwind/include"
	append-flags "-stdlib=libstdc++"
	# Enable futex in libc++abi to match prod toolchain.
	append-cppflags -D_LIBCXXABI_USE_FUTEX
	local libdir=$(get_libdir)
	local mycmakeargs=(
		"-DLLVM_ENABLE_PROJECTS=libcxxabi"
		"-DLIBCXXABI_LIBDIR_SUFFIX=${libdir#lib}"
		"-DLIBCXXABI_ENABLE_SHARED=ON"
		"-DLIBCXXABI_ENABLE_STATIC=$(usex static-libs)"
		"-DLIBCXXABI_USE_LLVM_UNWINDER=$(usex libunwind)"
		"-DLIBCXXABI_INCLUDE_TESTS=OFF"
		"-DCMAKE_INSTALL_PREFIX=${PREFIX}"
		"-DLIBCXXABI_LIBCXX_INCLUDES=${S}/libcxx/include"
		"-DLIBCXXABI_USE_COMPILER_RT=$(usex compiler-rt)"
	)

	# Update LLVM to 9.0 will cause LLVM to complain
	# libstdc++ version is old. Add this flag as suggested in the error
	# message.
	mycmakeargs+=(
		"-DLLVM_TEMPORARILY_ALLOW_OLD_TOOLCHAIN=1"
	)

	if use msan; then
		mycmakeargs+=(
			"-DLLVM_USE_SANITIZER=Memory"
		)
	fi

	cmake-utils_src_configure
}

multilib_src_install_all() {
	if [[ ${CATEGORY} == cross-* ]]; then
		rm -r "${ED}/usr/share/doc"
	fi
	insinto "${PREFIX}"/include/libcxxabi
	doins -r "${S}"/libcxxabi/include/.
}
