# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

: ${CMAKE_MAKEFILE_GENERATOR:=ninja}
CMAKE_MIN_VERSION=3.7.0-r1
PYTHON_COMPAT=( python2_7 )

inherit cros-constants cmake-utils git-r3 llvm python-any-r1 toolchain-funcs

DESCRIPTION="The LLVM linker (link editor)"
HOMEPAGE="https://llvm.org/"
SRC_URI=""
EGIT_REPO_URI="${CROS_GIT_HOST_URL}/external/llvm.org/lld
	https://git.llvm.org/git/lld.git"

EGIT_COMMIT="796666e779e6b7152be890c8d8fb52d2df06d268" #r349581

LICENSE="UoI-NCSA"
SLOT="0"
KEYWORDS="*"
IUSE="llvm-next"
RDEPEND="sys-devel/llvm"
DEPEND="${RDEPEND}"

pick_cherries() {
	CHERRIES=""
	CHERRIES+=" bb1399bcffdf5940bf6915affad8d2bd2744ba46" #r351186
	pushd "${S}" >/dev/null || die
	for cherry in ${CHERRIES}; do
		epatch "${FILESDIR}/cherry/${cherry}.patch"
	done
	popd >/dev/null || die
}

pick_next_cherries() {
	CHERRIES=""
	pushd "${S}" >/dev/null || die
	for cherry in ${CHERRIES}; do
		epatch "${FILESDIR}/cherry/${cherry}.patch"
	done
	popd >/dev/null || die
}

python_check_deps() {
	has_version "dev-python/lit[${PYTHON_USEDEP}]"
}

pkg_setup() {
	llvm_pkg_setup
}

src_unpack() {
	if use llvm-next && has_version --host-root 'sys-devel/llvm[llvm-next]'; then
		# llvm:353983 https://critique.corp.google.com/#review/233864070
		export EGIT_COMMIT="14aa57da0f92683f0b8bdac0acda485a6f73edc7" #r353981
	fi

	git-r3_fetch
	git-r3_checkout
}

src_prepare() {
	if use llvm-next  && has_version --host-root 'sys-devel/llvm[llvm-next]'; then
		pick_next_cherries
	else
		pick_cherries
	fi
	# These 2 patches are still reverted in Android.
	epatch "${FILESDIR}"/lld-8.0-revert-r326242.patch
	epatch "${FILESDIR}"/lld-8.0-revert-r325849.patch
	# Allow .elf suffix in lld binary name.
	epatch "${FILESDIR}/$PN-invoke-name.patch"
	# Put .text.hot section before .text section.
	epatch "${FILESDIR}"/lld-8.0-reorder-hotsection-early.patch
}
src_configure() {
	# HACK: This is a temporary hack to detect the c++ library used in libLLVM.so
	# lld needs to link with same library as llvm but there is no good way to find
	# that. So grep the libc++ usage and if not used link with libstdc++.
	# Remove this hack once everything is migrated to libc++.
	# https://crbug.com/801681
	if tc-is-clang; then
		if [[ -n $(scanelf -qN libc++.so.1 /usr/$(get_libdir)/libLLVM.so) ]]; then
			append-flags -stdlib=libc++
			append-ldflags -stdlib=libc++
		else
			append-flags -stdlib=libstdc++
			append-ldflags -stdlib=libstdc++
		fi
	fi
	# End HACK
	local mycmakeargs=(
		#-DBUILD_SHARED_LIBS=ON
		# TODO: fix detecting pthread upstream in stand-alone build
		-DPTHREAD_LIB='-lpthread'
	)
	if use llvm-next; then
		# Update LLD to next version will cause LLD to complain GCC
		# version is < 5.1. Add this flag to suppress the error.
		mycmakeargs+=(
			-DLLVM_TEMPORARILY_ALLOW_OLD_TOOLCHAIN=1
		)
	fi
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	local binpath="/usr/bin"
	mv "${D}${binpath}/lld" "${D}${binpath}/lld.real" || die
	exeinto "${binpath}"
	newexe "${FILESDIR}/ldwrapper" "lld" || die
}
