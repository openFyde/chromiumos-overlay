# Copyright 2020 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="2d9622a624880d0b83b1ccfa21d83fc66c0e1a39"
CROS_WORKON_TREE=("952d2f368a90cdfa98da94394d2a56079cef3597" "ca61f5a0dae6e07cee24a3142b10d90b12bf5fef" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
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
	chromeos-base/vboot_reference:=
"

patchpanel_client_header() {
	doins "$1"
	sed -i '/.pb.h/! s:patchpanel/:chromeos/patchpanel/:g' \
		"${D}/usr/include/chromeos/patchpanel/dbus/$1" || die
}

src_install() {
	platform_src_install

	# Libraries.
	dolib.so "${OUT}"/lib/libpatchpanel-client.so

	"${S}"/preinstall.sh "${PV}" "/usr/include/chromeos" "${OUT}" || die
	insinto "/usr/$(get_libdir)/pkgconfig"
	doins "${OUT}"/libpatchpanel-client.pc

	insinto /usr/include/chromeos/patchpanel/dbus
	patchpanel_client_header client.h
	patchpanel_client_header fake_client.h

	local fuzzer
	for fuzzer in "${OUT}"/*_fuzzer; do
		local fuzzer_component_id="156085"
		platform_fuzzer_install "${S}"/OWNERS "${fuzzer}" \
			--comp "${fuzzer_component_id}"
	done
}

platform_pkg_test() {
	platform_test "run" "${OUT}/patchpanel-client_testrunner"
}
