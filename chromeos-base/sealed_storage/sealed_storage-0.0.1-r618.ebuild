# Copyright 2019 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="bc24830adaa9cb63899421050784ce6306749985"
CROS_WORKON_TREE=("c70c24e7eeb0c8aad6108bedde29b6984f63cd54" "85f0ca7ef43dca43fd63cddd2c6fe576a3b18f30" "44b533b9e904bd46af6027adeb73b2256de03173" "dd83ff1c803209bfd296845ace6f8e9a7aab4ece" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
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
