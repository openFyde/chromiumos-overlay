# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

CROS_WORKON_COMMIT="2bc6c5f46a8d9ad66b6b78fbbdf724bd66bf2a10"
CROS_WORKON_TREE=("1c9dedfb489b146ba061dcc365b6be84de5528d8" "3726b6ff430b8eb9089dd662948c53f917b1bff7" "1a6ec33b8254dcd9134e68eb05cc3ba36070b0b1" "d8ac2ad180aa54028a051524d3717bd021e37f0c" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
# TODO(crbug.com/809389): Avoid directly including headers from other packages.
CROS_WORKON_SUBTREE="common-mk sealed_storage tpm_manager trunks .gn"

PLATFORM_SUBDIR="sealed_storage"

inherit cros-workon platform

DESCRIPTION="Library for sealing data to device identity and state"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/sealed_storage"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"

IUSE="test tpm2"

REQUIRED_USE="tpm2"
RDEPEND="
	chromeos-base/tpm_manager[test?]
	chromeos-base/trunks[test?]
"
DEPEND="${RDEPEND}
	chromeos-base/protofiles:=
	chromeos-base/system_api
"

src_install() {
	dosbin "${OUT}"/sealed_storage_tool
	dolib.a "${OUT}"/libsealed_storage.a
	dolib.so "${OUT}"/lib/libsealed_storage_wrapper.so
}

platform_pkg_test() {
	platform_test "run" "${OUT}/sealed_storage_testrunner"
}
