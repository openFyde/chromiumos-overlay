# Copyright (c) 2009 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

CROS_WORKON_BLACKLIST=1
CROS_WORKON_LOCALNAME="aosp/external/minijail"
CROS_WORKON_PROJECT="platform/external/minijail"
CROS_WORKON_REPO="https://android.googlesource.com"

# TODO(crbug.com/689060): Re-enable on ARM.
CROS_COMMON_MK_NATIVE_TEST="yes"

inherit cros-debug cros-sanitizers cros-workon cros-common.mk toolchain-funcs multilib

DESCRIPTION="helper binary and library for sandboxing & restricting privs of services"
HOMEPAGE="https://android.googlesource.com/platform/external/minijail"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="~*"
IUSE="asan +seccomp test"

RDEPEND="sys-libs/libcap
	!<chromeos-base/chromeos-minijail-1"
DEPEND="${RDEPEND}
	test? (
		dev-cpp/gtest
		dev-cpp/gmock
	)"

src_configure() {
	sanitizers-setup-env
	cros-common.mk_src_configure
	export LIBDIR="/$(get_libdir)"
	export USE_seccomp=$(usex seccomp)
	export USE_SYSTEM_GTEST=yes
}

src_install() {
	into /
	dosbin "${OUT}"/minijail0
	dolib.so "${OUT}"/libminijail{,preload}.so

	doman minijail0.[15]

	local include_dir="/usr/include/chromeos"

	"${S}"/platform2_preinstall.sh "${PV}" "${include_dir}"
	insinto "/usr/$(get_libdir)/pkgconfig"
	doins libminijail.pc

	insinto "${include_dir}"
	doins libminijail.h
	doins scoped_minijail.h
}
