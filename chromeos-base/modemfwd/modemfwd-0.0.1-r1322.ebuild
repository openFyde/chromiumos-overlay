# Copyright 2017 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="cbba8c413a1cae7db84ea0dcd910b4f4a01ce167"
CROS_WORKON_TREE=("b9c8b8315a832ea4cfd3cb10367bc58e9a3ecb2a" "6aeb64d112325ba29ac82c4ca505fe329c1967e7" "a2002e5b021a481c966a494642397c400fe65c93" "561bcc05765480e8dc10a5a0a3a5e061b24bd83d" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk chromeos-config metrics modemfwd .gn"

PLATFORM_SUBDIR="modemfwd"

inherit cros-workon platform tmpfiles user

DESCRIPTION="Modem firmware updater daemon"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/modemfwd"

LICENSE="BSD-Google"
SLOT="0/0"
KEYWORDS="*"
IUSE="fuzzer"

COMMON_DEPEND="
	app-arch/xz-utils:=
	chromeos-base/chromeos-config:=
	chromeos-base/chromeos-config-tools:=
	chromeos-base/dlcservice-client:=
	chromeos-base/metrics:=
	dev-libs/protobuf:=
	net-misc/modemmanager-next:=
"

RDEPEND="${COMMON_DEPEND}"

DEPEND="${COMMON_DEPEND}
	chromeos-base/shill-client:=
	chromeos-base/system_api:=[fuzzer?]
	fuzzer? ( dev-libs/libprotobuf-mutator:= )
"

src_install() {
	platform_src_install

	dotmpfiles tmpfiles.d/*.conf

	local fuzzer_component_id="167157"
	platform_fuzzer_install "${S}"/OWNERS "${OUT}"/firmware_manifest_v2_fuzzer \
		--comp "${fuzzer_component_id}"
}

platform_pkg_test() {
	platform test_all
}
