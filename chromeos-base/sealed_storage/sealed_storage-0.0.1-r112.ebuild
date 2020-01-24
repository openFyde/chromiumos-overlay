# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="47c7f847879bc350067d4eda4038d1151cc0abc2"
CROS_WORKON_TREE=("e27f1b4637c4d92b0c7b14963d2910ad6b0b631e" "c1acdfd25150d1d1a2c39886eba26787f8cb4b3c" "28af022d0cd64b2b362a1fd8ce62f3ba0a5adfb2" "df79ace968ccac3eaf6f75d3b8b59ac6cbfde107" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
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
	dosbin "${OUT}"/sealed_storage_tool
	dolib.a "${OUT}"/libsealed_storage.a
	dolib.so "${OUT}"/lib/libsealed_storage_wrapper.so

	insinto /usr/include/chromeos/sealed_storage
	doins sealed_storage.h
}

platform_pkg_test() {
	platform_test "run" "${OUT}/sealed_storage_testrunner"
}
