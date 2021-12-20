# Copyright 2021 The Chromium OS Authors. All rights reserved.
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

DEPEND="
	>=dev-rust/backtrace-0.3.51 <dev-rust/backtrace-0.4.0_alpha:=
"
RDEPEND="${DEPEND}"

# This file was automatically generated by cargo2ebuild.py

RESTRICT="test"
