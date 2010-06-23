# Copyright (c) 2009 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=2

inherit flag-o-matic toolchain-funcs cros-workon

DESCRIPTION="Bridge library for Chromium OS"
HOMEPAGE="http://src.chromium.org"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~arm"
IUSE="debug"

RDEPEND="app-i18n/ibus
	chromeos-base/flimflam
	dev-libs/dbus-glib
	 dev-libs/glib
	dev-libs/libpcre
	net-libs/gupnp
	net-libs/gupnp-av
	sys-apps/dbus
	sys-auth/consolekit
	sys-fs/udev
	x11-apps/setxkbmap
	x11-libs/libxklavier"
# TODO(suzhe): Remove x11-apps/setxkbmap when issue 2536 is fixed.

DEPEND="${RDEPEND}
	chromeos-base/libchrome
	chromeos-base/libchromeos
	chromeos-base/update_engine
	dev-cpp/gtest"

CROS_WORKON_PROJECT="cros"
CROS_WORKON_LOCALNAME=${CROS_WORKON_PROJECT}

src_compile() {
	use debug || append-flags -DNDEBUG
	if tc-is-cross-compiler ; then
		tc-getCC
		tc-getCXX
		tc-getAR
		tc-getRANLIB
		tc-getLD
		tc-getNM
		tc-getPROG PKG_CONFIG pkg-config
		export PKG_CONFIG_PATH="${ROOT}/usr/lib/pkgconfig/"
		export CCFLAGS="$CFLAGS"
	fi

	scons -f SConstruct.chromiumos || die "cros compile failed."
	# Add -fPIC when building libcrosapi.a so that it works on ARM
	export CCFLAGS="$CCFLAGS -fPIC"
	scons -f SConstruct.chromiumos crosapi || die "crosapi compile failed."
}

src_test() {
	if tc-is-cross-compiler ; then
		tc-getCC
		tc-getCXX
		tc-getAR
		tc-getRANLIB
		tc-getLD
		tc-getNM
		tc-getPROG PKG_CONFIG pkg-config
		export PKG_CONFIG_PATH="${ROOT}/usr/lib/pkgconfig/"
		export CCFLAGS="$CFLAGS"
	fi

	scons -f SConstruct.chromiumos test || die "cros tests compile failed."
}

src_install() {
	dolib.a "${S}/libcrosapi.a"

	insinto /usr/include/cros
	doins *.h

	insinto /opt/google/chrome/chromeos
	insopts -m0755
	doins "${S}/libcros.so"
}
