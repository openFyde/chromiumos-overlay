# Copyright 2014 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="89446db7e58492539f535081060e8aff42983913"
CROS_WORKON_TREE=("81f7fe23bf497aafef6d4128b33582b4422a9ff5" "1edbe1922d28a3b7a7be0992dcd17e71674b8c77" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk libbrillo .gn"

PLATFORM_SUBDIR="libbrillo"

# platform.eclass automatically add dependency to libbrillo by default,
# but this package should not have the dependency.
WANT_LIBBRILLO="no"

inherit cros-workon multilib platform

DESCRIPTION="Base library for Chromium OS"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/libbrillo/"

LICENSE="BSD-Google"
SLOT="0/${PV}.0"
KEYWORDS="*"
IUSE="cros_host +dbus +device_mapper fuzzer +udev"

COMMON_DEPEND="
	chromeos-base/minijail:=
	dbus? ( dev-libs/dbus-glib:= )
	dev-libs/openssl:=
	dev-libs/protobuf:=
	net-misc/curl:=
	sys-apps/rootdev:=
	device_mapper? ( sys-fs/lvm2:= )
	udev? ( virtual/libudev )
"
RDEPEND="
	${COMMON_DEPEND}
	!cros_host? ( chromeos-base/libchromeos-use-flags )
	chromeos-base/chromeos-ca-certificates
	!chromeos-base/libchromeos
"
DEPEND="
	${COMMON_DEPEND}
	>=chromeos-base/protofiles-0.0.35:=
	dbus? ( chromeos-base/system_api:=[fuzzer?] )
	dev-libs/modp_b64:=
"

src_install() {
	local v
	insinto "/usr/$(get_libdir)/pkgconfig"
	for v in "${LIBCHROME_VERS[@]}"; do
		dolib.so "${OUT}"/lib/lib{brillo,installattributes,policy}*-"${v}".so
		dolib.a "${OUT}"/libbrillo*-"${v}".a
		doins "${OUT}"/obj/libbrillo/libbrillo*-"${v}".pc
	done

	# Install all the header files from libbrillo/brillo/*.h into
	# /usr/include/brillo (recursively, with sub-directories).
	local dir
	while read -d $'\0' -r dir; do
		insinto "/usr/include/${dir}"
		doins "${dir}"/*.h
	done < <(find brillo -type d -print0)

	insinto /usr/include/policy
	doins policy/*.h
	insinto /usr/include/install_attributes
	doins install_attributes/libinstallattributes.h

	platform_fuzzer_install "${S}"/OWNERS "${OUT}"/libbrillo_data_encoding_fuzzer
	platform_fuzzer_install "${S}"/OWNERS \
		"${OUT}"/libbrillo_dbus_data_serialization_fuzzer
	platform_fuzzer_install "${S}"/OWNERS "${OUT}"/libbrillo_http_form_data_fuzzer
}

platform_pkg_test() {
	local v
	for v in "${LIBCHROME_VERS[@]}"; do
		platform_test "run" "${OUT}/libbrillo-${v}_tests"
		platform_test "run" "${OUT}/libinstallattributes-${v}_tests"
		platform_test "run" "${OUT}/libpolicy-${v}_tests"
	done
}
