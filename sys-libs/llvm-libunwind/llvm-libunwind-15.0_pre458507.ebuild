# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

CROS_WORKON_REPO="${CROS_GIT_HOST_URL}"
CROS_WORKON_PROJECT="external/github.com/llvm/llvm-project"
CROS_WORKON_LOCALNAME="llvm-project"
CROS_WORKON_MANUAL_UPREV=1

inherit cros-fuzzer cros-sanitizers cros-constants cmake-multilib cmake-utils git-2 cros-llvm cros-workon

DESCRIPTION="C++ runtime stack unwinder from LLVM"
HOMEPAGE="https://github.com/llvm-mirror/libunwind"
SRC_URI=""
EGIT_REPO_URI="${CROS_GIT_HOST_URL}/external/github.com/llvm/llvm-project
	${CROS_GIT_HOST_URL}/external/github.com/llvm/llvm-project"
EGIT_BRANCH=main

LLVM_HASH="a58d0af058038595c93de961b725f86997cf8d4a" # r458507
LLVM_NEXT_HASH="db1978b67431ca3462ad8935bf662c15750b8252" # r465103

LICENSE="|| ( UoI-NCSA MIT )"
SLOT="0"
KEYWORDS="*"
if [[ "${PV}" == "9999" ]]; then
	KEYWORDS="~*"
fi
IUSE="cros_host debug llvm-next llvm-tot +static-libs +shared-libs +synth_libgcc +compiler-rt continue-on-patch-failure"
RDEPEND="!${CATEGORY}/libunwind"

DEPEND="${RDEPEND}
	cros_host? ( sys-devel/llvm )"

pkg_setup() {
	# Setup llvm toolchain for cross-compilation
	setup_cross_toolchain
	export CMAKE_USE_DIR="${S}/runtimes"
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
	local failure_mode
	failure_mode="$(usex continue-on-patch-failure continue fail)"
	"${FILESDIR}"/patch_manager/patch_manager.py \
		--svn_version "$(get_most_recent_revision)" \
		--patch_metadata_file "${FILESDIR}"/PATCHES.json \
		--failure_mode "${failure_mode}" \
		--src_path "${S}" || die

	eapply_user
}

should_enable_asserts() {
	if use debug || use llvm-tot; then
		echo yes
	else
		echo no
	fi
}

multilib_src_configure() {
	# Disable sanitization of llvm-libunwind (b/193934733).
	use_sanitizers && filter_sanitizers

	# Filter default portage flags to allow unwinding.
	cros_enable_cxx_exceptions
	append-cppflags "-D_LIBUNWIND_USE_DLADDR=0"
	if [[ ${CATEGORY} == cross-armv7a* ]] ; then
		# Allow targeting non-neon targets for armv7a.
		append-flags -mfpu=vfpv3

		# cross-armv7 builds fail due a to libgcc_eh.a bootstrap bug
		# due to a global variable used for stack canary memory.
		# https://bugzilla.redhat.com/show_bug.cgi?id=708452
		# https://gcc.gnu.org/bugzilla/show_bug.cgi?id=102352
		# TODO(toolchain): Revisit this when the above GCC bug is
		# fixed or we have glibc arm clang build support.
		append-flags -fno-stack-protector
	fi

	local libdir=$(get_libdir)
	local mycmakeargs=(
		"${mycmakeargs[@]}"
		"-DCMAKE_TRY_COMPILE_TARGET_TYPE=STATIC_LIBRARY"
		"-DCMAKE_POSITION_INDEPENDENT_CODE=ON"
		"-DLLVM_LIBDIR_SUFFIX=${libdir#lib}"
		"-DLIBUNWIND_ENABLE_ASSERTIONS=$(should_enable_asserts)"
		"-DLIBUNWIND_ENABLE_STATIC=$(usex static-libs)"
		"-DLIBUNWIND_ENABLE_SHARED=OFF"
		"-DLIBUNWIND_ENABLE_THREADS=OFF"
		"-DLIBUNWIND_ENABLE_CROSS_UNWINDING=OFF"
		"-DLIBUNWIND_USE_COMPILER_RT=$(usex compiler-rt)"
		"-DLIBUNWIND_TARGET_TRIPLE=$(get_abi_CTARGET)"
		"-DCMAKE_INSTALL_PREFIX=${PREFIX}"
		"-DLLVM_ENABLE_RUNTIMES=libunwind"
		# Avoid old libstdc++ errors when bootstrapping.
		"-DLLVM_ENABLE_LIBCXX=ON"
		"-DLIBUNWIND_HAS_COMMENT_LIB_PRAGMA=OFF"
		"-DLIBUNWIND_HAS_DL_LIB=OFF"
		"-DLIBUNWIND_HAS_PTHREAD_LIB=OFF"
	)

	if is_baremetal_abi; then
		# Options for baremetal toolchains e.g. armv7m-cros-eabi.
		mycmakeargs+=(
			"-DCMAKE_POSITION_INDEPENDENT_CODE=OFF"
			"-DLIBUNWIND_IS_BAREMETAL=ON"
			"-DLIBUNWIND_REMEMBER_HEAP_ALLOC=ON"
		)
	fi

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

multilib_src_install() {
	cmake-utils_src_install
	if is_baremetal_abi; then
		return
	fi

	# Generate libunwind.so or libgcc_s.so.
	local myabi=$(get_abi_CTARGET)
	if [[ ${myabi} == *armv7a* ]]; then
		LIBGCC_ARCH="armhf"
	elif [[ ${myabi} == *aarch64* ]]; then
		LIBGCC_ARCH="aarch64"
	elif [[ ${myabi} =~ ^i[0-9]86 ]]; then
		LIBGCC_ARCH="i386"
	elif [[ ${myabi} == *x86_64* ]] ; then
		LIBGCC_ARCH="x86_64"
	else
		echo "unsupported arch" && die
	fi

	local COMPILER_RT_BUILTINS=$($(tc-getCC) -print-libgcc-file-name -rtlib=compiler-rt)
	local my_installdir="${D%/}${PREFIX}/$(get_libdir)"
	local out_file soname

	if use synth_libgcc; then
		out_file=libgcc_s.so.1
		soname=libgcc_s.so.1
	else
		out_file=libunwind.so.1.0
		soname=libunwind.so.1
	fi

	echo "Creating ${out_file} using libunwind.a + compiler-rt".
	# Ignore split word warnings, we need them for flags.
	# shellcheck disable=SC2086
	$(tc-getCC) -o "${my_installdir}"/"${out_file}"                                 \
		${CFLAGS}                                                                   \
		${LDFLAGS}                                                                  \
		-shared                                                                     \
		-nostdlib                                                                   \
		-Wl,--whole-archive                                                         \
		-Wl,--version-script,"${FILESDIR}/version-scripts/gcc_s-${LIBGCC_ARCH}.ver" \
		-Wl,-soname,"${soname}"                                                     \
		"${COMPILER_RT_BUILTINS}"                                                   \
		"${my_installdir}"/libunwind.a                                              \
		-Wl,--no-whole-archive                                                      \
		-lm                                                                         \
		-lc                                                                         \
	|| die "Failed to create ${out_file}".

	# Point libunwind.so.1, libunwind_shared.so and libunwind.so to libunwind.so.1.0.
	ln -s libunwind.so.1.0 "${my_installdir}"/libunwind.so.1 || die
	ln -s libunwind.so.1   "${my_installdir}"/libunwind.so || die
	ln -s libunwind.so     "${my_installdir}"/libunwind_shared.so || die

	# Generate libgcc{,_eh,_s} if requested.
	if use synth_libgcc; then
		# We already created libgcc_s.so.1 if we are here.
		# Point libunwind.so.1.0 and libgcc_s.so to it.
		# Also make sure that libgcc.a and libgcc_eh.a point to compiler-rt/libunwind.
		ln -s libgcc_s.so.1 "${my_installdir}"/libunwind.so.1.0 || die
		ln -s libgcc_s.so.1 "${my_installdir}"/libgcc_s.so || die
		ln -s libunwind.a "${my_installdir}"/libgcc_eh.a || die
		cp "${COMPILER_RT_BUILTINS}" "${my_installdir}"/libgcc.a || die
	fi
}
