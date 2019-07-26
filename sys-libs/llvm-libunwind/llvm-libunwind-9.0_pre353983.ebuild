# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit cros-constants cmake-multilib cmake-utils git-2 cros-llvm

DESCRIPTION="C++ runtime stack unwinder from LLVM"
HOMEPAGE="https://github.com/llvm-mirror/libunwind"
SRC_URI=""
EGIT_REPO_URI="${CROS_GIT_HOST_URL}/external/github.com/llvm/llvm-project"

# llvm:353983 https://critique.corp.google.com/#review/233864070
LLVM_HASH="de7a0a152648d1a74cf4319920b1848aa00d1ca3" #r353983
LLVM_NEXT_HASH="de7a0a152648d1a74cf4319920b1848aa00d1ca3" #r353983

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
	export CMAKE_USE_DIR="${S}/libunwind"
}

src_unpack() {
	if use llvm-next; then
		export EGIT_COMMIT="${LLVM_NEXT_HASH}"
	else
		export EGIT_COMMIT="${LLVM_HASH}"
	fi
	git-2_src_unpack
}

src_prepare() {
	python "${FILESDIR}"/patch_manager.py \
		--svn_version "$(get_most_recent_revision)" \
		--git_hash "$(get_most_recent_sha)" \
		--patch_metadata_file "${FILESDIR}"/PATCHES.json \
		--filesdir_path "${FILESDIR}" \
		--src_path "${S}" || die
}

multilib_src_configure() {
	# Allow targeting non-neon targets for armv7a.
	if [[ ${CATEGORY} == cross-armv7a* ]] ; then
		append-flags -mfpu=vfpv3
	fi
	local libdir=$(get_libdir)
	local mycmakeargs=(
		"${mycmakeargs[@]}"
		-DLLVM_ENABLE_PROJECTS="libunwind"
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

multilib_src_install_all() {
	# Remove files that are installed by sys-libs/llvm-libunwind
	# to avoid collision when installing cross-${TARGET}/llvm-libunwind.
	if [[ ${CATEGORY} == cross-* ]]; then
		rm -rf "${ED}"usr/share || die
	fi

	# Install headers.
	insinto "${PREFIX}"/include
	doins -r "${S}"/libunwind/include/.
}
