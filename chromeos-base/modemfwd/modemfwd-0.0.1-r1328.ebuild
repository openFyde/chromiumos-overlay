# Copyright 2017 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="82313d97f9ce8208babe02d19d757ddb70728b0e"
CROS_WORKON_TREE=("6350979dbc8b7aa70c83ad8a03dded778848025d" "f9559bb24ca0c0f08cfd600f978e909fd34f8d4e" "a2002e5b021a481c966a494642397c400fe65c93" "c02753f02828f41722716be374b8c62a0e74e9b2" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
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

	insinto /usr/share/policy
	newins "seccomp/modemfwd-mbimcli-seccomp-${ARCH}.policy" modemfwd-mbimcli-seccomp.policy
}

platform_pkg_test() {
	platform test_all
}
