# Copyright 2021 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="90efbf3c872c8b343053b4f8cceb26c4bbe80751"
CROS_WORKON_TREE=("45d2d3f6225f2e66796a2a4a833460156c777c42" "7d782850d4c8ec5eba684d05eae05fb16dbe18bd" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
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
	chromeos-base/session_manager-client:=
	chromeos-base/system_api:=
	sys-apps/dbus:="

src_install() {
	into /
	dosbin "${OUT}"/featured

	insinto "/usr/$(get_libdir)/pkgconfig"
	dolib.so "${OUT}/lib/libfeatures.so"
	dolib.so "${OUT}/lib/libfeatures_c.so"
	dolib.so "${OUT}/lib/libfake_platform_features.so"
	dolib.so "${OUT}/lib/libc_fake_feature_library.so"
	local v="$(libchrome_ver)"
	./platform2_preinstall.sh "${OUT}" "${v}"
	doins "${OUT}/lib/libfeatures.pc"
	doins "${OUT}/lib/libfeatures_c.pc"

	insinto "/usr/include/featured"
	doins feature_export.h
	doins c_feature_library.h
	doins feature_library.h
	doins c_fake_feature_library.h
	doins fake_platform_features.h

	# Install DBus configuration.
	insinto /etc/dbus-1/system.d
	doins share/org.chromium.featured.conf

	insinto /etc/init
	doins share/featured.conf share/featured-chrome-restart.conf

	dodir /etc/featured
	insinto /etc/featured
	fperms 0764 /etc/featured
	doins share/platform-features.json

	local fuzzer_component_id="1096648"
	platform_fuzzer_install "${S}"/OWNERS \
			"${OUT}"/featured_json_feature_parser_fuzzer \
			--comp "${fuzzer_component_id}"
}

platform_pkg_test() {
	platform_test "run" "${OUT}/feature_library_test"
	platform_test "run" "${OUT}/service_test"
}
