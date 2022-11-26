# Copyright 2022 The ChromiumOS Authors
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI=7

CROS_WORKON_COMMIT="de753d03811d7bc21fa5af140cbeca48de5a390b"
CROS_WORKON_TREE="ce320186f7363bb7aca9b2edde7d12ecba4750eb"
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_SUBTREE="hwsec-utils"

inherit cros-workon cros-rust

DESCRIPTION="Hwsec-related features."
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/hwsec-utils/"

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE="cr50_onboard generic_tpm2 test ti50_onboard"
REQUIRED_USE="^^ ( ti50_onboard cr50_onboard generic_tpm2 )"
CANDIDATES=( "cr50_onboard" "generic_tpm2" "ti50_onboard" )

DEPEND="dev-rust/third-party-crates-src:="
# (crbug.com/1182669): build-time only deps need to be in RDEPEND so they are pulled in when
# installing binpkgs since the full source tree is required to use the crate.
RDEPEND="${DEPEND}
	cr50_onboard? ( chromeos-base/chromeos-cr50 )
"

src_compile() {
	local features=()

	local candidate
	for candidate in "${CANDIDATES[@]}"; do
		if use "${candidate}"; then
			features+=("${candidate}")
		fi
	done

	cros-rust_src_compile --features="${features[*]}"
}

src_install() {
	cros-rust_src_install
	dobin "$(cros-rust_get_build_dir)/tpm2_read_board_id"
}

src_test() {
	local features=()

	local candidate
	for candidate in "${CANDIDATES[@]}"; do
		if use "${candidate}"; then
			features+=("${candidate}")
		fi
	done

	cros-rust_src_test --features="${features[*]}"
}
