# Copyright 2020 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="4025aab4f7da05fe2b8c37fd89a2943d4e72f794"
CROS_WORKON_TREE=("8fad85aa9518e1a0f04272ae9e077c4a4036297d" "f611f9af53c863ec586a17cc34cf0cc3f42a7fd7" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
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

DEPEND="
	chromeos-base/system_api:=
	chromeos-base/shill-client:=
	chromeos-base/shill-net
"
RDEPEND="${DEPEND}"

src_install() {
	platform_src_install

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
