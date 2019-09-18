# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

CROS_WORKON_COMMIT="efd63e90495fb3c4d8fb1081b558899a96c8861d"
CROS_WORKON_TREE=("6d0a1403799ea9191481152a885383fce1fe4713" "caf72d5b22c53f818a57aa27ef86b3e4b9e4f310" "2d2a3b213aa02bf9b9991b314581ad0db096396d" "fda343644d509468f777bd4c0d2054daef34e9e9" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
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
