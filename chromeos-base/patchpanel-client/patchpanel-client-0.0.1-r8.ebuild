# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="321f23bd09a39dc9f3c4f97286b45f58d05504f1"
CROS_WORKON_TREE=("825512278f3738ba8ac7c5f167aacd4677cfebf7" "383ebd06e89533ad0288dfbcd9d657b66eae310f" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk patchpanel .gn"

PLATFORM_SUBDIR="patchpanel/dbus"

inherit cros-workon platform

DESCRIPTION="Patchpanel network connectivity management D-Bus client"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/patchpanel/dbus/"
LICENSE="BSD-Google"
KEYWORDS="*"

# These USE flags are used in patchpanel/dbus/BUILD.gn
IUSE="fuzzer"

COMMON_DEPEND="
	dev-libs/protobuf:=
"

# libpatchpanel-client.so and libpatchpanel-client.pc moved from
# chromeos-base/patchpanel.
RDEPEND="
	!<chromeos-base/patchpanel-0.0.2
	${COMMON_DEPEND}
"

DEPEND="
	${COMMON_DEPEND}
	chromeos-base/system_api:=[fuzzer?]
"

patchpanel_client_header() {
	doins "$1"
	sed -i '/.pb.h/! s:patchpanel/:chromeos/patchpanel/dbus/:g' \
		"${D}/usr/include/chromeos/patchpanel/dbus/$1" || die
}

src_install() {
	# Libraries.
	dolib.so "${OUT}"/lib/libpatchpanel-client.so

	"${S}"/preinstall.sh "${PV}" "/usr/include/chromeos" "${OUT}" || die
	insinto "/usr/$(get_libdir)/pkgconfig"
	doins "${OUT}"/libpatchpanel-client.pc

	insinto /usr/include/chromeos/patchpanel/dbus
	patchpanel_client_header client.h

	local fuzzer
	for fuzzer in "${OUT}"/*_fuzzer; do
		platform_fuzzer_install "${S}"/OWNERS "${fuzzer}"
	done
}

platform_pkg_test() {
	platform_test "run" "${OUT}/patchpanel-client_testrunner"
}
