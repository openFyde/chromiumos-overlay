# Copyright 2022 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

CROS_RUST_REMOVE_DEV_DEPS=1

# We don't set CROS_RUST_REMOVE_TARGET_CFG=1 because that would remove the
# dependency on atomic-polyfill, which is needed.

inherit cros-rust

DESCRIPTION="\"static\" friendly data structures that don't require dynamic memory allocation"
HOMEPAGE='https://crates.io/crates/heapless'
SRC_URI="https://crates.io/api/v1/crates/${PN}/${PV}/download -> ${P}.crate"

LICENSE="|| ( MIT Apache-2.0 )"
SLOT="${PV}/${PR}"
KEYWORDS="*"

DEPEND="
	>=dev-rust/defmt-0.2.0 <dev-rust/defmt-0.4.0_alpha
	>=dev-rust/hash32-0.2.1 <dev-rust/hash32-0.3.0_alpha
	>=dev-rust/atomic-polyfill-0.1.8 <dev-rust/atomic-polyfill-0.2.0
	>=dev-rust/spin-0.9.2 <dev-rust/spin-0.10.0
	=dev-rust/serde-1*
	=dev-rust/stable_deref_trait-1*
	=dev-rust/ufmt-write-0.1*
	=dev-rust/rustc_version-0.4*
"
RDEPEND="${DEPEND}"

# This file was automatically generated by cargo2ebuild.py
