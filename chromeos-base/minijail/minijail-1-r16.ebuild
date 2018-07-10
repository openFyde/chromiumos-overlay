# Copyright (c) 2009 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

CROS_WORKON_COMMIT="31b02653c2560f8331934e879263beda44c6cc76"
CROS_WORKON_TREE="f85a9ff43dbe382bab0fcaf3f95593165c1e125b"
CROS_WORKON_BLACKLIST=1
CROS_WORKON_LOCALNAME="aosp/external/minijail"
CROS_WORKON_PROJECT="platform/external/minijail"
CROS_WORKON_REPO="https://android.googlesource.com"

inherit cros-debug cros-workon toolchain-funcs

DESCRIPTION="helper binary and library for sandboxing & restricting privs of services"
HOMEPAGE="https://android.googlesource.com/platform/external/minijail"
SRC_URI=""

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE="asan +seccomp test"

RDEPEND="sys-libs/libcap
	!<chromeos-base/chromeos-minijail-1"
DEPEND="test? ( dev-cpp/gtest )
	test? ( dev-cpp/gmock )
	${RDEPEND}"

src_configure() {
	asan-setup-env
	cros-workon_src_configure
}

src_compile() {
	# Only build the tools.
	emake LIBDIR=$(get_libdir) USE_seccomp=$(usex seccomp)
}

src_test() {
	# TODO(crbug.com/689060): Re-enable on ARM.
	if use x86 || use amd64 ; then
		emake USE_SYSTEM_GTEST=yes tests
	fi
}

src_install() {
	into /
	dosbin minijail0
	dolib.so libminijail.so
	dolib.so libminijailpreload.so

	doman minijail0.[15]

	local include_dir="/usr/include/chromeos"

	"${S}"/platform2_preinstall.sh "${PV}" "${include_dir}"
	insinto "/usr/$(get_libdir)/pkgconfig"
	doins libminijail.pc

	insinto "${include_dir}"
	doins libminijail.h
	doins scoped_minijail.h
}
