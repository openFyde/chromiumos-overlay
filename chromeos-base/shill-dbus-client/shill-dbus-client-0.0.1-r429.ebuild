# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="8da5794b7f8d4c5b7597effac594ce4664c5545c"
CROS_WORKON_TREE=("36abcf818b30e23dcd5eb99dc81916cb4af6ec56" "9191f11da313662a9bb54b69b7ff03a5fa4a353d" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_SUBTREE="common-mk shill .gn"

PLATFORM_SUBDIR="shill/dbus/client"

inherit cros-workon platform

DESCRIPTION="Shill DBus client interface library"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/shill/dbus/client"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE=""

DEPEND="chromeos-base/shill-client:="
RDEPEND=""

src_install() {
	# Install libshill-dbus-client library.
	insinto "/usr/$(get_libdir)/pkgconfig"
	local v="$(libchrome_ver)"
	./preinstall.sh "${OUT}" "${v}"
	dolib.so "${OUT}/lib/libshill-dbus-client.so"
	doins "${OUT}/lib/libshill-dbus-client.pc"

	# Install header files from libshill-dbus-client.
	insinto /usr/include/shill/dbus/client
	doins ./*.h
}

platform_pkg_test() {
	platform_test "run" "${OUT}/libshill-dbus-client_test"
}
