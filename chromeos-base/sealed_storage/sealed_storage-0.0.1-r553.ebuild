# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="6fe7d6dfc8195e79e025fcc5ec79dee49e989971"
CROS_WORKON_TREE=("f13fe6260d63162b9e22bba96b94c30874378934" "ebd80d3e9a0d5136bc9154864fc7c23cea4a5861" "5587ba130f4f8585cd1df3d775cf8eb4ef191bf6" "7b1cdef33d4a81cd41de215f22e8f5fb1ed34f09" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
# TODO(crbug.com/809389): Avoid directly including headers from other packages.
CROS_WORKON_SUBTREE="common-mk sealed_storage tpm_manager trunks .gn"

PLATFORM_SUBDIR="sealed_storage"

inherit cros-workon platform

DESCRIPTION="Library for sealing data to device identity and state"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/sealed_storage"

LICENSE="BSD-Google"
KEYWORDS="*"

IUSE="test tpm2"

REQUIRED_USE="tpm2"
COMMON_DEPEND="
	chromeos-base/tpm_manager:=[test?]
	chromeos-base/trunks:=[test?]
"
RDEPEND="${COMMON_DEPEND}"
DEPEND="${COMMON_DEPEND}
	chromeos-base/protofiles:=
	chromeos-base/system_api:=
"

src_install() {
	platform_install
}

platform_pkg_test() {
	platform test_all
}
