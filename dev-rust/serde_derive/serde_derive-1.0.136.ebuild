# Copyright 2022 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

CROS_RUST_REMOVE_DEV_DEPS=1

inherit cros-rust

DESCRIPTION='Macros 1.1 implementation of #[derive(Serialize, Deserialize)]'
HOMEPAGE='https://serde.rs'
SRC_URI="https://crates.io/api/v1/crates/${PN}/${PV}/download -> ${P}.crate"

LICENSE="|| ( MIT Apache-2.0 )"
SLOT="${PV}/${PR}"
KEYWORDS="*"

DEPEND="
	=dev-rust/proc-macro2-1*
	=dev-rust/quote-1*
	>=dev-rust/syn-1.0.60 <dev-rust/syn-2.0.0_alpha
"
RDEPEND="${DEPEND}"

# This file was automatically generated by cargo2ebuild.py
