# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="874c2a7bd09b0c6b0d944efa2b859ae51da414c3"
CROS_WORKON_TREE=("ba51cdbc1f93611f21a434aa8577a98ed1e9d5f8" "f12a59864323dd8b496989477c8cb062881e9dca" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_DESTDIR="${S}/platform2"
CROS_WORKON_SUBTREE="common-mk hammerd .gn"

PLATFORM_SUBDIR="hammerd"

inherit cros-workon platform user

DESCRIPTION="A daemon to update EC firmware of hammer, the base of the detachable."
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/hammerd/"

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE="-hammerd_api fuzzer"

RDEPEND="
	chromeos-base/ec-utils:=
	>=chromeos-base/metrics-0.0.1-r3152:=
	chromeos-base/vboot_reference:=
	dev-libs/openssl:0=
	sys-apps/flashmap:=
"
DEPEND="
	${RDEPEND}
	chromeos-base/system_api:=[fuzzer?]
"

pkg_preinst() {
	# Create user and group for hammerd
	enewuser "hammerd"
	enewgroup "hammerd"
}

src_install() {
	platform_install

	local fuzzer_component_id="167114"
	platform_fuzzer_install "${S}"/OWNERS "${OUT}"/hammerd_load_ec_image_fuzzer \
		--comp "${fuzzer_component_id}"
	platform_fuzzer_install "${S}"/OWNERS "${OUT}"/hammerd_update_fw_fuzzer \
		--comp "${fuzzer_component_id}"
}

platform_pkg_test() {
	platform test_all
}
