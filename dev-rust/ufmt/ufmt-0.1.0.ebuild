# Copyright 2021 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

CROS_RUST_REMOVE_DEV_DEPS=1

inherit cros-rust

DESCRIPTION='A (6-40x) smaller, (2-9x) faster and panic-free alternative to "core::fmt"'
HOMEPAGE='https://crates.io/crates/ufmt'
SRC_URI="https://crates.io/api/v1/crates/${PN}/${PV}/download -> ${P}.crate"

LICENSE="|| ( MIT Apache-2.0 )"
SLOT="${PV}/${PR}"
KEYWORDS="*"

DEPEND="
	>=dev-rust/proc-macro-hack-0.5.11 <dev-rust/proc-macro-hack-0.6.0
	=dev-rust/ufmt-macros-0.1*
	=dev-rust/ufmt-write-0.1*
"
RDEPEND="${DEPEND}"

# This file was automatically generated by cargo2ebuild.py
