# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit cros-constants cmake-multilib cmake-utils git-2 cros-llvm

DESCRIPTION="C++ runtime stack unwinder from LLVM"
HOMEPAGE="https://github.com/llvm-mirror/libunwind"
SRC_URI=""
EGIT_REPO_URI="${CROS_GIT_HOST_URL}/external/llvm.org/libunwind"

# llvm:353983 https://critique.corp.google.com/#review/233864070
export EGIT_COMMIT="317087cfd8e608bd24e53934d59b5b85e0a9ded6" #r353208

LICENSE="|| ( UoI-NCSA MIT )"
SLOT="0"
KEYWORDS="*"
IUSE="cros_host debug llvm-next +static-libs +shared-libs"
RDEPEND="!${CATEGORY}/libunwind"

DEPEND="${RDEPEND}
	cros_host? ( sys-devel/llvm )"

pkg_setup() {
	# Setup llvm toolchain for cross-compilation
	setup_cross_toolchain
}

src_unpack() {
	if use llvm-next; then
		# llvm:353983 https://critique.corp.google.com/#review/233864070
		export EGIT_COMMIT="317087cfd8e608bd24e53934d59b5b85e0a9ded6" #r353208
	fi
	git-2_src_unpack
}

pick_cherries() {
	local CHERRIES=""
	CHERRIES+="2ae4f16e7a3c5b6493b5eddbd76f231f3923eee0"
	pushd "${S}" >/dev/null || die
	for cherry in ${CHERRIES}; do
		epatch "${FILESDIR}/cherry/${cherry}.patch"
	done
	popd >/dev/null || die
}

pick_next_cherries() {
	local CHERRIES=""
	CHERRIES+="2ae4f16e7a3c5b6493b5eddbd76f231f3923eee0"
	pushd "${S}" >/dev/null || die
	for cherry in ${CHERRIES}; do
		epatch "${FILESDIR}/cherry/${cherry}.patch"
	done
	popd >/dev/null || die
}

src_prepare() {
	use llvm-next || pick_cherries
	use llvm-next && pick_next_cherries
}

multilib_src_configure() {
	# Allow targeting non-neon targets for armv7a.
	if [[ ${CATEGORY} == cross-armv7a* ]] ; then
		append-flags -mfpu=vfpv3
	fi
	local libdir=$(get_libdir)
	local mycmakeargs=(
		"${mycmakeargs[@]}"
		-DCMAKE_TRY_COMPILE_TARGET_TYPE=STATIC_LIBRARY
		-DLLVM_LIBDIR_SUFFIX=${libdir#lib}
		-DLIBUNWIND_ENABLE_ASSERTIONS=$(usex debug)
		-DLIBUNWIND_ENABLE_STATIC=$(usex static-libs)
		-DLIBUNWIND_ENABLE_SHARED=$(usex shared-libs)
		-DLIBUNWIND_TARGET_TRIPLE=${CTARGET}
		-DLIBUNWIND_ENABLE_THREADS=OFF
		-DLIBUNWIND_ENABLE_CROSS_UNWINDING=ON
		-DCMAKE_INSTALL_PREFIX=${PREFIX}
		# Avoid old libstdc++ errors when bootstrapping.
		-DLLVM_ENABLE_LIBCXX=ON
	)

	cmake-utils_src_configure
}

multilib_src_install() {
	cmake-utils_src_install
	# Install headers.
	insinto "${PREFIX}"/include
	doins -r "${S}"/include/.
}
