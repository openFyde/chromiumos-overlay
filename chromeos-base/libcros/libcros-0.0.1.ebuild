# Copyright (c) 2009 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=2

inherit toolchain-funcs

DESCRIPTION="Bridge library for Chromium OS"
HOMEPAGE="http://src.chromium.org"
LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86 arm"

# TODO: chromeos-base/synaptics is not a run-time dependency, but until
# we can stop using --root-deps=rdeps we have to explicitly add it as a
# run-time dependency here. It can't go in hard-target-depends because it
# depends on stuff in hard-target-depends.
RDEPEND="app-i18n/ibus
	 chromeos-base/synaptics
	 chromeos-base/flimflam
         dev-libs/dbus-glib
         dev-libs/glib
         dev-libs/libpcre
         sys-apps/dbus
         sys-auth/consolekit
         sys-fs/udev"

DEPEND="${RDEPEND}
	chromeos-base/libchrome
        chromeos-base/libchromeos
	chromeos-base/synaptics"

src_unpack() {
        local platform="${CHROMEOS_ROOT}/src/platform/"
        elog "Using platform: $platform"
        mkdir -p "${S}"
        cp -a "${platform}"/cros/* "${S}" || die
}

src_compile() {
        if tc-is-cross-compiler ; then
                tc-getCC
                tc-getCXX
                tc-getAR
                tc-getRANLIB
                tc-getLD
                tc-getNM
                export PKG_CONFIG_PATH="${ROOT}/usr/lib/pkgconfig/"
                export CCFLAGS="$CFLAGS"
        fi

        scons -f SConstruct.chromiumos || die "cros compile failed."
}

src_install() {
        insinto /opt/google/chrome/chromeos
	insopts -m0755
	doins "${S}/libcros.so"
}
