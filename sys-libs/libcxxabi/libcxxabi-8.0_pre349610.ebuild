# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

: ${CMAKE_MAKEFILE_GENERATOR:=ninja}
PYTHON_COMPAT=( python2_7 )

inherit cmake-multilib cros-constants cros-llvm flag-o-matic git-2 llvm python-any-r1

DESCRIPTION="Low level support for a standard C++ library"
HOMEPAGE="http://libcxxabi.llvm.org/"

SRC_URI=""
EGIT_REPO_URI="${CROS_GIT_HOST_URL}/external/llvm.org/libcxxabi"

EGIT_REPO_URIS=(
	"libcxxabi"
		""
		"${CROS_GIT_HOST_URL}/external/llvm.org/libcxxabi"
		"307bb62985575b2e3216a8cfd7e122e0574f33a9" #r347903
	"libcxx"
		"libcxx"
		"${CROS_GIT_HOST_URL}/external/llvm.org/libcxx"
		"9ff404deecb2b3d02b219f3e841aa8837a1f654e" #r349566
	"libunwind_llvm"
		"libunwind_llvm"
		"${CROS_GIT_HOST_URL}/external/llvm.org/libunwind"
		"9defb52f575beff21b646e60e63f72ad1ac7cf54" #r349532
)

LICENSE="|| ( UoI-NCSA MIT )"
SLOT="0"
KEYWORDS="*"
IUSE="+compiler-rt cros_host libunwind msan llvm-next +static-libs test"

RDEPEND="
	libunwind? (
			|| (
				>=${CATEGORY}/libunwind-1[static-libs?,${MULTILIB_USEDEP}]
				>=${CATEGORY}/llvm-libunwind-3.9.0-r1[static-libs?,${MULTILIB_USEDEP}]
			)
	)
	!cros_host? ( sys-libs/gcc-libs )"

DEPEND="${RDEPEND}
	cros_host? ( sys-devel/llvm )
	test? ( >=sys-devel/clang-3.9.0
		~sys-libs/libcxx-${PV}[libcxxabi(-)]
		$(python_gen_any_dep 'dev-python/lit[${PYTHON_USEDEP}]') )"

python_check_deps() {
	has_version "dev-python/lit[${PYTHON_USEDEP}]"
}

pkg_setup() {
	setup_cross_toolchain
	llvm_pkg_setup
	use test && python-any-r1_pkg_setup
}

src_unpack() {
	if use llvm-next; then
		EGIT_REPO_URIS=(
		"libcxxabi"
			""
			"${CROS_GIT_HOST_URL}/external/llvm.org/libcxxabi"
			"307bb62985575b2e3216a8cfd7e122e0574f33a9" #r347903
		"libcxx"
			"libcxx"
			"${CROS_GIT_HOST_URL}/external/llvm.org/libcxx"
			"9ff404deecb2b3d02b219f3e841aa8837a1f654e" #r349566
		"libunwind_llvm"
			"libunwind_llvm"
			"${CROS_GIT_HOST_URL}/external/llvm.org/libunwind"
			"9defb52f575beff21b646e60e63f72ad1ac7cf54" #r349532
		)
	fi
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

src_prepare() {
	# Link with libgcc_eh when compiler-rt is used.
	epatch "${FILESDIR}"/libcxxabi-7-use-libgcc_eh.patch
}

multilib_src_configure() {
	# Filter sanitzers flags.
	filter_sanitizers
	# Use vpfv3 fpu to be able to target non-neon targets.
	if [[ $(tc-arch) == "arm" ]] ; then
		append-flags -mfpu=vfpv3
	fi
	append-flags -I"${S}/libunwind_llvm/include"
	append-flags "-stdlib=libstdc++"
	local libdir=$(get_libdir)
	local mycmakeargs=(
		-DLIBCXXABI_LIBDIR_SUFFIX=${libdir#lib}
		-DLIBCXXABI_ENABLE_SHARED=ON
		-DLIBCXXABI_ENABLE_STATIC=$(usex static-libs)
		-DLIBCXXABI_USE_LLVM_UNWINDER=$(usex libunwind)
		-DLIBCXXABI_INCLUDE_TESTS=$(usex test)
		-DCMAKE_INSTALL_PREFIX="${PREFIX}"
		-DLIBCXXABI_LIBCXX_INCLUDES="${S}"/libcxx/include
		-DLIBCXXABI_USE_COMPILER_RT=$(usex compiler-rt)
	)

	if use msan; then
		mycmakeargs+=(
			-DLLVM_USE_SANITIZER=Memory
		)
	fi

	if use test; then
		mycmakeargs+=(
			-DLIT_COMMAND="${EPREFIX}"/usr/bin/lit
		)
	fi
	cmake-utils_src_configure
}

multilib_src_test() {
	local clang_path=$(type -P "${CHOST:+${CHOST}-}clang" 2>/dev/null)

	[[ -n ${clang_path} ]] || die "Unable to find ${CHOST}-clang for tests"
	sed -i -e "/cxx_under_test/s^\".*\"^\"${clang_path}\"^" test/lit.site.cfg || die

	cmake-utils_src_make check-libcxxabi
}

multilib_src_install_all() {
	if [[ ${CATEGORY} == cross-* ]]; then
		rm -r "${ED}/usr/share/doc"
	fi
	insinto "${PREFIX}"/include/libcxxabi
	doins -r include/.
}
