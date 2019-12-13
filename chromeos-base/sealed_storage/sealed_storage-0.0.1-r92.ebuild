# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

CROS_WORKON_COMMIT="efcaf836bd1e6486c495b780cb0edc81768c1fff"
CROS_WORKON_TREE=("27d7d5f2d4de786738c22f9ded288cce7eed6a7c" "e61fc9eec58f232aa0a62acf639d58e1d506b3ac" "a10541b781bce7a5076c93a9b3d44e47e3b378b9" "3c679089f3bda24fecdd19918e96cf2b72e8f9a0" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
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
