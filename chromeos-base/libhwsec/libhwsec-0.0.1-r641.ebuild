# Copyright 2019 The ChromiumOS Authors
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI=7

CROS_WORKON_COMMIT="51de882c758cbb9ae92c7ade70469069d0ea6540"
CROS_WORKON_TREE=("0f4044624c1fabe638a8289e62ec74756aa62176" "f6551f3dde891a75473f1b97fb7d0c5829e6be91" "c1195005f152ed453ed87250e60e2dfa9502a6c4" "e1f223c8511c80222f764c8768942936a8de01e4" "d260dea390c888b42d26362d30dfb99591d69489" "901ae2b9c072acbc41c41d68a617643b541c3634" "4009d6eb6c6d27c7d2a35604226089fd0190d345" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
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
