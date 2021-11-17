# Copyright 2021 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="4e3e96dad453519e99d6f570554122515b1a5f4b"
CROS_WORKON_TREE=("9d87849894323414dd9afca425cb349d84a71f6b" "d5b9c4d726f99127339f8e0cf121a304f1314fdd" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_INCREMENTAL_BUILD="1"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk featured .gn"

PLATFORM_SUBDIR="featured"

inherit cros-workon platform user

DESCRIPTION="Chrome OS feature management service"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/featured/"
LICENSE="BSD-Google"
KEYWORDS="*"
IUSE="test"

DEPEND="
	chromeos-base/system_api:=
	sys-apps/dbus:="

src_install() {
	into /
	dosbin "${OUT}"/featured

	insinto "/usr/$(get_libdir)/pkgconfig"
	dolib.so "${OUT}/lib/libfeatures.so"
	dolib.so "${OUT}/lib/libfeatures_c.so"
	local v="$(libchrome_ver)"
	./platform2_preinstall.sh "${OUT}" "${v}"
	doins "${OUT}/lib/libfeatures.pc"
	doins "${OUT}/lib/libfeatures_c.pc"

	# Install DBus configuration.
	insinto /etc/dbus-1/system.d
	doins share/org.chromium.featured.conf

	insinto /etc/init
	doins share/featured.conf share/platform-features.json
}

platform_pkg_test() {
	platform_test "run" "${OUT}/feature_library_test"
}
