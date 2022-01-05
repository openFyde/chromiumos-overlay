# Copyright 2022 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

CROS_RUST_REMOVE_DEV_DEPS=1

inherit cros-rust

DESCRIPTION='Flexible concrete Error type built on std::error::Error'
HOMEPAGE='https://crates.io/crates/anyhow'
SRC_URI="https://crates.io/api/v1/crates/${PN}/${PV}/download -> ${P}.crate"

LICENSE="|| ( MIT Apache-2.0 )"
SLOT="${PV}/${PR}"
KEYWORDS="*"

# This should be >=dev-rust/backtrace-0.3.51 <dev-rust/backtrace-0.4.0_alpha:= but is
# set to 0.3* as a hack until https://crbug.com/1284710 is resolved.
DEPEND="
	=dev-rust/backtrace-0.3*:=
"
RDEPEND="${DEPEND}"
