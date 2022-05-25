# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="216cd7fe32a4ac248b1d39781ec3e5bb8c761d8f"
CROS_WORKON_TREE=("f65480a28376b309e5661d94fbb53f8904006444" "c1897bb4c0f4580eba4b1fae6e991b84bdc69775" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
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
	chromeos-base/shill-client:=
	chromeos-base/shill-net
"
RDEPEND="${DEPEND}"

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
