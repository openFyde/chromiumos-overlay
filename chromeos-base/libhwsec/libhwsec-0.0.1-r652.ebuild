# Copyright 2019 The ChromiumOS Authors
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI=7

CROS_WORKON_COMMIT="f8e92f82ea101d20f4f2368ce236c32f43171f39"
CROS_WORKON_TREE=("3f8a9a04e17758df936e248583cfb92fc484e24c" "bf7ee9b5db1b58824379460401d235a902ae0847" "0da6813244ce2b1b6119bea74143530e6a6623e9" "e1f223c8511c80222f764c8768942936a8de01e4" "072df1207e0e9f112b41c87c1488eac7d3a2e837" "901ae2b9c072acbc41c41d68a617643b541c3634" "4009d6eb6c6d27c7d2a35604226089fd0190d345" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk libhwsec libhwsec-foundation metrics tpm_manager tpm2-simulator trunks .gn"

PLATFORM_SUBDIR="libhwsec"

inherit cros-workon platform

DESCRIPTION="Crypto and utility functions used in TPM related daemons."
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/libhwsec/"

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE="test fuzzer tpm tpm2 tpm_dynamic"

COMMON_DEPEND="
	chromeos-base/libhwsec-foundation:=
	chromeos-base/metrics:=
	chromeos-base/tpm_manager-client:=
	dev-libs/openssl:0=
	dev-libs/flatbuffers:=
	tpm2? (
		chromeos-base/pinweaver:=
		chromeos-base/trunks:=[test?]
	)
	tpm? ( app-crypt/trousers:= )
	fuzzer? (
		app-crypt/trousers:=
		chromeos-base/trunks:=
	)
	test? (
		app-crypt/trousers:=
		chromeos-base/pinweaver:=
		chromeos-base/trunks:=[test]
		chromeos-base/tpm2-simulator:=[test]
	)
"

RDEPEND="${COMMON_DEPEND}"
DEPEND="${COMMON_DEPEND}"

src_configure() {
	if use test; then
		# b/261541399: Many test files for libhwsec take 1-2GB of RAM to
		# build each. If run on a bot (-j32) or dev machine (-j64+),
		# this can lead to pretty huge memory consumption. Limit that.
		#
		# Non-`FEATURES=test` builds don't require nearly as much RAM,
		# so those can use the standard job limit.
		if [[ $(makeopts_jobs) -gt 8 ]]; then
			export MAKEOPTS="${MAKEOPTS} --jobs 8"
		fi
	fi
	platform_src_configure
}

platform_pkg_test() {
	platform test_all
}
