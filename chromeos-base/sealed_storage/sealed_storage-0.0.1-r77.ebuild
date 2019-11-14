# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

CROS_WORKON_COMMIT="228371d6b5efb1b4e5c9171058e9e6d3034ba33f"
CROS_WORKON_TREE=("1319841568b5f67d3de28c685396b374735f5d15" "e61fc9eec58f232aa0a62acf639d58e1d506b3ac" "4aa72d025149303c5db01a50621f57e8a131f6a4" "e800a683ab02b73ce07ca73e09eb675047c8b83c" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
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
