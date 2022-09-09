# Copyright 2022 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

CROS_RUST_REMOVE_DEV_DEPS=1

inherit cros-rust

DESCRIPTION='Procedural macros of the cortex-m-rtic crate'
HOMEPAGE='https://crates.io/crates/cortex-m-rtic-macros'
SRC_URI="https://crates.io/api/v1/crates/${PN}/${PV}/download -> ${P}.crate"

LICENSE="|| ( MIT Apache-2.0 )"
SLOT="${PV}/${PR}"
KEYWORDS="*"

DEPEND="
	=dev-rust/proc-macro-error-1*
	=dev-rust/proc-macro2-1*
	=dev-rust/quote-1*
	>=dev-rust/rtic-syntax-1.0.2 <dev-rust/rtic-syntax-2.0.0_alpha
	=dev-rust/syn-1*
"
RDEPEND="${DEPEND}"

# This file was automatically generated by cargo2ebuild.py
