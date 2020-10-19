# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit eutils flag-o-matic binutils-funcs toolchain-funcs

DESCRIPTION="Stressful Application Test"
HOMEPAGE="https://github.com/stressapptest/stressapptest"
SRC_URI="https://github.com/stressapptest/stressapptest/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="*"

# By assigning USE="cros_arm64" in private overlay, we'll build 64-bits version
# of stressapptest.
IUSE="debug cros_arm64"

RDEPEND="dev-libs/libaio"
DEPEND="${RDEPEND}"

src_prepare() {
	eapply "${FILESDIR}"/${PN}-gnu_cxx-namespace.patch
	eapply "${FILESDIR}"/0001-include-stdint.h.patch
	eapply_user
}

src_configure() {
	local econf_args="--disable-default-optimizations"
	local sysroot="${SYSROOT}"

	if use cros_arm64 && use arm; then
		unset CFLAGS CXXFLAGS CPPFLAGS LDFLAGS

		# The following logic is copied from cros-kernel2.eclass
		export CHOST=aarch64-cros-linux-gnu
		export CTARGET=aarch64-cros-linux-gnu
		export ABI=arm64
		unset CC CXX LD STRIP OBJCOPY PKG_CONFIG

		tc-export_build_env BUILD_{CC,CXX}
		tc-export CC CXX LD STRIP OBJCOPY PKG_CONFIG
		local binutils_path=$(LD=${CHOST}-ld get_binutils_path_ld)

		export LD="${LD}"
		export CC="${CC} -B${binutils_path}"
		export CC_COMPAT="${CC_COMPAT}"
		export CXX="${CXX} -B${binutils_path}"

		econf_args+=" --with-static"
		sysroot=""
	fi

	# Matches the configure & sat.cc logic.
	use debug || append-cppflags -DNDEBUG -DCHECKOPTS
	SYSROOT="${sysroot}" econf ${econf_args}
}

src_compile() {
	local sysroot="${SYSROOT}"

	if use cros_arm64 && use arm; then
		# Use headers and libraries from "/" instead of "/build/${BOARD}"
		sysroot=""
	fi

	SYSROOT="${sysroot}" emake
}
