# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI=7

CROS_WORKON_COMMIT="68549f380efec20216b34da328379434e82ce62d"
CROS_WORKON_TREE=("fa0cbc93948c0945c099fb259c924c4d6623ab91" "f7122dee369efc8a9c0fff9f33ad43b0ae9a9aef" "21548273647aef951959159c27d36d02ece3bf40" "927316874088e984336a22471ee7df8302ced987" "36ee9b6e080b025be54503eaeb956c35148ae402" "178951b1096a4a34481380e0d917124103fcb692" "ff04749290c7f103811b7f9c3f03dde4494590e3" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="attestation common-mk hwsec-test-utils libhwsec libhwsec-foundation tpm_manager trunks .gn"

PLATFORM_SUBDIR="hwsec-test-utils"

inherit cros-workon platform

DESCRIPTION="Hwsec-related test-only features. This package resides in test images only."
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/hwsec-test-utils/"

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE="test tpm tpm_dynamic tpm2"
REQUIRED_USE="
	tpm_dynamic? ( tpm tpm2 )
	!tpm_dynamic? ( ?? ( tpm tpm2 ) )
"

RDEPEND="
	tpm2? (
		chromeos-base/trunks:=
	)
	tpm? (
		app-crypt/trousers:=
	)
	chromeos-base/libhwsec:=
"

DEPEND="${RDEPEND}
	tpm2? (
		chromeos-base/trunks:=[test?]
	)
	chromeos-base/attestation:=
	chromeos-base/libhwsec-foundation:=
	chromeos-base/system_api:=
	dev-libs/openssl:=
	dev-libs/protobuf:=
"

src_install() {
	platform_install
}

platform_pkg_test() {
	platform test_all
}
