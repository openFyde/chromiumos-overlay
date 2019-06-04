# Copyright 2014 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

CROS_WORKON_COMMIT="d86d31f4c43703835ac24c602e7684fc72d7ea98"
CROS_WORKON_TREE=("f354d140e04d861ac5457214dd14961f6c512112" "b4daabbc3b100bf2a75e94645807a90b4884785a" "dc1506ef7c8cfd2c5ffd1809dac05596ec18773c")
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk libbrillo .gn"

PLATFORM_SUBDIR="libbrillo"

inherit cros-workon multilib platform

DESCRIPTION="Base library for Chromium OS"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/libbrillo/"

LICENSE="BSD-Google"
SLOT="0/${PV}.0"
KEYWORDS="*"
IUSE="cros_host +dbus +device_mapper"

COMMON_DEPEND="
	chromeos-base/minijail
	dbus? ( dev-libs/dbus-glib )
	dev-libs/openssl:=
	dev-libs/protobuf:=
	net-misc/curl
	sys-apps/rootdev
	device_mapper? ( sys-fs/lvm2 )
"
RDEPEND="
	${COMMON_DEPEND}
	!cros_host? ( chromeos-base/libchromeos-use-flags )
	chromeos-base/chromeos-ca-certificates
	!chromeos-base/libchromeos
"
DEPEND="
	${COMMON_DEPEND}
	chromeos-base/protofiles
	dbus? ( chromeos-base/system_api:= )
	dev-libs/modp_b64
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
}

platform_pkg_test() {
	local v
	for v in "${LIBCHROME_VERS[@]}"; do
		platform_test "run" "${OUT}/libbrillo-${v}_tests"
		platform_test "run" "${OUT}/libinstallattributes-${v}_tests"
		platform_test "run" "${OUT}/libpolicy-${v}_tests"
	done
}
