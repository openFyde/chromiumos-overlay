# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit multilib-minimal arc-build-constants

DESCRIPTION="Ebuild for per-sysroot arc-build components."

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"

RDEPEND=""
DEPEND=""

S=${WORKDIR}
PREBUILT_SRC="${ARC_BASE}/${ARCH}/usr"

multilib_src_compile() {
	arc-build-constants-configure

	cat > pkg-config <<EOF
#!/bin/bash
case \${ABI} in
aarch64|amd64)
	libdir=lib64
	;;
arm|x86)
	libdir=lib
	;;
*)
	echo "Unsupported ABI: \${ABI}" >&2
	exit 1
	;;
esac

PKG_CONFIG_LIBDIR="${SYSROOT}${ARC_PREFIX}/vendor/\${libdir}/pkgconfig"
export PKG_CONFIG_LIBDIR

export PKG_CONFIG_SYSROOT_DIR="${SYSROOT}"

# Portage will get confused and try to "help" us by exporting this.
# Undo that logic.
unset PKG_CONFIG_PATH

exec pkg-config "\$@"
EOF
}

install_pc_file() {
	prefix="${ARC_PREFIX}/usr"
	sed \
		-e "s|@lib@|$(get_libdir)|g" \
		-e "s|@prefix@|${prefix}|g" \
		"${PC_SRC_DIR}"/"$1" > "$1" || die
	doins "$1"
}

multilib_src_install() {
	local bin_dir="${ARC_PREFIX}/build/bin"
	local prebuilt_dir="${ARC_PREFIX}/usr"

	PC_SRC_DIR="${FILESDIR}/${ARC_VERSION_CODENAME}"

	insinto "${ARC_PREFIX}/vendor/$(get_libdir)/pkgconfig"
	install_pc_file backtrace.pc
	install_pc_file cutils.pc
	install_pc_file expat.pc
	install_pc_file hardware.pc
	install_pc_file mediandk.pc
	install_pc_file pthread-stubs.pc
	install_pc_file sync.pc
	install_pc_file zlib.pc

	if [[ "${ARC_VERSION_CODENAME}" != "nyc" ]]; then
		install_pc_file nativewindow.pc
	fi

	exeinto "${bin_dir}"
	doexe pkg-config

	dosym "${PREBUILT_SRC}" "${prebuilt_dir}"
}
