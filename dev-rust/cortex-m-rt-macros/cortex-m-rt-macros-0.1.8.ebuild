# Copyright 2021 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

CROS_RUST_REMOVE_DEV_DEPS=1

inherit cros-rust

DESCRIPTION='Attributes re-exported in "cortex-m-rt"'
HOMEPAGE='https://crates.io/crates/cortex-m-rt-macros'
SRC_URI="https://crates.io/api/v1/crates/${PN}/${PV}/download -> ${P}.crate"

LICENSE="|| ( MIT Apache-2.0 )"
SLOT="${PV}/${PR}"
KEYWORDS="*"

DEPEND="
	=dev-rust/proc-macro2-1*
	=dev-rust/quote-1*
	=dev-rust/syn-1*
"
RDEPEND="${DEPEND}"

# This file was automatically generated by cargo2ebuild.py
