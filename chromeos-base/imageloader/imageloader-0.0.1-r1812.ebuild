# Copyright 2016 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="07142f9f6a43b6ea73aae8e8a763eacc6bb13391"
CROS_WORKON_TREE=("850bb15d6483ae4ed294e5a64907e57835f3232d" "4a4f108b6a611c3bf7694f7f604454f1e98d0c03" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk imageloader .gn"

PLATFORM_SUBDIR="imageloader"

inherit cros-workon platform user

DESCRIPTION="Allow mounting verified utility images"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/imageloader/"

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE="fuzzer"

RDEPEND="
	chromeos-base/vboot_reference:=
	chromeos-base/minijail:=
	dev-libs/openssl:=
	dev-libs/protobuf:=
	fuzzer? ( dev-libs/libprotobuf-mutator:= )
	sys-fs/lvm2:="

DEPEND="${RDEPEND}
	chromeos-base/system_api:=[fuzzer?]"

src_install() {
	platform_src_install

	local fuzzer_component_id="188251"
	platform_fuzzer_install "${S}"/OWNERS "${OUT}"/imageloader_helper_process_receiver_fuzzer \
		--comp "${fuzzer_component_id}"
	platform_fuzzer_install "${S}"/OWNERS "${OUT}"/imageloader_manifest_fuzzer \
		--dict "${S}"/fuzz/manifest.dict \
		--comp "${fuzzer_component_id}"
}

platform_pkg_test() {
	platform test_all
}

pkg_preinst() {
	enewuser "imageloaderd"
	enewgroup "imageloaderd"
}
