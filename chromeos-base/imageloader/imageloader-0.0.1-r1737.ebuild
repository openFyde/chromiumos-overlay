# Copyright 2016 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="09c5bc2d23a4e625fdd74032e385e630e9caa0bb"
CROS_WORKON_TREE=("e7f63c823468db13a24ebe2323042c054c4316c9" "060f8cc11d5c225cbca811a28dab5962bd897b84" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
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
	platform_install

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
