# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit cros-constants cmake-utils git-2 cros-llvm

DESCRIPTION="C++ runtime stack unwinder from LLVM"
HOMEPAGE="https://github.com/llvm-mirror/libunwind"
SRC_URI=""
EGIT_REPO_URI="${CROS_GIT_HOST_URL}/external/llvm.org/libunwind"
EGIT_COMMIT="0eea5e270b455f79c59df69b8fb38f68399314a2"

LICENSE="|| ( UoI-NCSA MIT )"
SLOT="0"
KEYWORDS="*"
IUSE="debug +static-libs"
RDEPEND="!${CATEGORY}/libunwind"

src_unpack() {
	git-2_src_unpack
}

src_configure() {
	# Setup llvm toolchain for cross-compilation
	setup_cross_toolchain

	# Add neon fpu for armv7a
	if [[ ${CATEGORY} == cross-armv7a* ]] ; then
		append-flags -mfpu=neon
	fi

	local mycmakeargs=(
		"${mycmakeargs[@]}"
		-DLIBUNWIND_ENABLE_ASSERTIONS=$(usex debug)
		-DLIBUNWIND_ENABLE_STATIC=$(usex static-libs)
		-DLIBUNWIND_ENABLE_SHARED=$(usex !static-libs)
		-DLIBUNWIND_TARGET_TRIPLE=${CTARGET}
	)

	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	# install headers like sys-libs/libunwind
	insinto "${PREFIX}"/include
	doins -r include/.
}
