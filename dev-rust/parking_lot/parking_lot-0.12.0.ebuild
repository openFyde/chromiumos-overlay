# Copyright 2022 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

CROS_RUST_REMOVE_DEV_DEPS=1

inherit cros-rust

DESCRIPTION='More compact and efficient implementations of the standard synchronization primitives.'
HOMEPAGE='https://crates.io/crates/parking_lot'
SRC_URI="https://crates.io/api/v1/crates/${PN}/${PV}/download -> ${P}.crate"

LICENSE="|| ( Apache-2.0 MIT )"
SLOT="${PV}/${PR}"
KEYWORDS="*"

DEPEND="
	>=dev-rust/lock_api-0.4.6 <dev-rust/lock_api-0.5.0_alpha:=
	=dev-rust/parking_lot_core-0.9*:=
"
RDEPEND="${DEPEND}"

# This file was automatically generated by cargo2ebuild.py
