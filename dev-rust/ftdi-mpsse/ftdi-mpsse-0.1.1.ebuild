# Copyright 2022 The ChromiumOS Authors.
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

CROS_RUST_REMOVE_DEV_DEPS=1

inherit cros-rust

DESCRIPTION='Rust helpers for the MPSSE on FTDI chips.'
HOMEPAGE='https://crates.io/crates/ftdi-mpsse'
SRC_URI="https://crates.io/api/v1/crates/${PN}/${PV}/download -> ${P}.crate"

LICENSE="MIT"
SLOT="${PV}/${PR}"
KEYWORDS="*"

DEPEND="
	>=dev-rust/static_assertions-1.1.0 <dev-rust/static_assertions-2.0.0_alpha
"
RDEPEND="${DEPEND}"

# This file was automatically generated by cargo2ebuild.py
