# Copyright 2021 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="e92727bf39e3da0b90088f041d1f0521a4492ce9"
CROS_WORKON_TREE=("2cf4c35678adb92c195b64eced57e539eaf07f08" "e6d3266e1144e97a3914f1e4116368b08b29b4c6" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
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

	local fuzzer_component_id="1096648"
	platform_fuzzer_install "${S}"/OWNERS \
			"${OUT}"/featured_json_feature_parser_fuzzer \
			--comp "${fuzzer_component_id}"
}

platform_pkg_test() {
	platform_test "run" "${OUT}/feature_library_test"
}
