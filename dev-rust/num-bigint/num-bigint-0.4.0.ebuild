# Copyright 2021 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

CROS_RUST_REMOVE_DEV_DEPS=1

inherit cros-rust

DESCRIPTION='Big integer implementation for Rust'
HOMEPAGE='https://github.com/rust-num/num-bigint'
SRC_URI="https://crates.io/api/v1/crates/${PN}/${PV}/download -> ${P}.crate"

LICENSE="|| ( MIT Apache-2.0 )"
SLOT="${PV}/${PR}"
KEYWORDS="*"

DEPEND="
	=dev-rust/arbitrary-1*
	>=dev-rust/num-integer-0.1.42 <dev-rust/num-integer-0.2.0
	>=dev-rust/num-traits-0.2.11 <dev-rust/num-traits-0.3.0
	=dev-rust/quickcheck-1*
	=dev-rust/rand-0.8*
	=dev-rust/serde-1*
	=dev-rust/autocfg-1*
"
RDEPEND="${DEPEND}"

# This file was automatically generated by cargo2ebuild.py
