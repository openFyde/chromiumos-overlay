# Copyright 2017 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="1c77f6728f1b4aabd016a79bdccabeba93680f9b"
CROS_WORKON_TREE=("3f8a9a04e17758df936e248583cfb92fc484e24c" "228253f42ff8d7ad8a68376e05e600e650aaa1c2" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_DESTDIR="${S}/platform2"
CROS_WORKON_SUBTREE="common-mk hammerd .gn"

PLATFORM_SUBDIR="hammerd"

inherit cros-workon platform user

DESCRIPTION="A daemon to update EC firmware of hammer, the base of the detachable."
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/hammerd/"

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
	platform_src_install

	local fuzzer_component_id="167114"
	platform_fuzzer_install "${S}"/OWNERS "${OUT}"/hammerd_load_ec_image_fuzzer \
		--comp "${fuzzer_component_id}"
	platform_fuzzer_install "${S}"/OWNERS "${OUT}"/hammerd_update_fw_fuzzer \
		--comp "${fuzzer_component_id}"
}

platform_pkg_test() {
	platform test_all
}
