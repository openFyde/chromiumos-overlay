# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit cros-constants cmake-multilib cmake-utils git-2 cros-llvm

DESCRIPTION="C++ runtime stack unwinder from LLVM"
HOMEPAGE="https://github.com/llvm-mirror/libunwind"
SRC_URI=""
EGIT_REPO_URI="${CROS_GIT_HOST_URL}/external/llvm.org/libunwind"

EGIT_COMMIT="1e73ceedf467eebae88c3f560c680cee3c527f24" #r339259

LICENSE="|| ( UoI-NCSA MIT )"
SLOT="0"
KEYWORDS="*"
IUSE="debug llvm-next +static-libs +shared-libs"
RDEPEND="!${CATEGORY}/libunwind"

pkg_setup() {
	# Setup llvm toolchain for cross-compilation
	setup_cross_toolchain
}

src_unpack() {
	if use llvm-next; then
		export EGIT_COMMIT="1e73ceedf467eebae88c3f560c680cee3c527f24" #r339259
	fi
	git-2_src_unpack
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
	)

	cmake-utils_src_configure
}

multilib_src_install() {
	cmake-utils_src_install
	# Install headers.
	insinto "${PREFIX}"/include
	doins -r "${S}"/include/.
}
