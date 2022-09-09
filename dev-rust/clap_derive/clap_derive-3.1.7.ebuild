# Copyright 2022 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

CROS_RUST_REMOVE_DEV_DEPS=1

inherit cros-rust

DESCRIPTION='Parse command line argument by defining a struct, derive crate.'
HOMEPAGE='https://crates.io/crates/clap_derive'
SRC_URI="https://crates.io/api/v1/crates/${PN}/${PV}/download -> ${P}.crate"

LICENSE="|| ( MIT Apache-2.0 )"
SLOT="${PV}/${PR}"
KEYWORDS="*"

DEPEND="
	=dev-rust/heck-0.4*
	=dev-rust/proc-macro-error-1*
	>=dev-rust/proc-macro2-1.0.28 <dev-rust/proc-macro2-2.0.0_alpha
	>=dev-rust/quote-1.0.9 <dev-rust/quote-2.0.0_alpha
	>=dev-rust/syn-1.0.74 <dev-rust/syn-2.0.0_alpha
"
RDEPEND="${DEPEND}"

# This file was automatically generated by cargo2ebuild.py
