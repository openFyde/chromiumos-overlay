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

LICENSE="UoI-NCSA"
SLOT="0"
KEYWORDS="*"
IUSE="llvm-next"
RDEPEND="sys-devel/llvm"
DEPEND="${RDEPEND}"

pick_cherries() {
	CHERRIES=""
	pushd "${S}" >/dev/null || die
	for cherry in ${CHERRIES}; do
		epatch "${FILESDIR}/cherry/${cherry}.patch"
	done
	popd >/dev/null || die
}

pick_next_cherries() {
	CHERRIES=""
	CHERRIES+=" b0befbe9bc302945656f58e72429225d934b4837" # r336594
	CHERRIES+=" bd5fbef9c29ce6433a93ddbbf7c4ef185bc1d1d5" # r337195
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
	EGIT_COMMIT="cd60a0adc5a8b2dc38b564d353c22543f1bc45b6" #r331538

	if use llvm-next && has_version --host-root 'sys-devel/llvm[llvm-next]'; then
		EGIT_COMMIT="8611960159f18591cb319ae527a6559d0861224e" #r333793
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
	epatch "${FILESDIR}/$PN-invoke-name.patch"
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
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	local binpath="/usr/bin"
	mv "${D}${binpath}/lld" "${D}${binpath}/lld.real" || die
	exeinto "${binpath}"
	newexe "${FILESDIR}/ldwrapper" "lld" || die
}
