# Copyright 2022 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

CROS_RUST_REMOVE_DEV_DEPS=1

inherit cros-rust

DESCRIPTION="Simple bit field trait providing get_bit, get_bits, set_bit, and set_bits methods for Rust's integral types."
HOMEPAGE='https://crates.io/crates/bit_field'
SRC_URI="https://crates.io/api/v1/crates/${PN}/${PV}/download -> ${P}.crate"

LICENSE="|| ( Apache-2.0 MIT )"
SLOT="${PV}/${PR}"
KEYWORDS="*"


# This file was automatically generated by cargo2ebuild.py
