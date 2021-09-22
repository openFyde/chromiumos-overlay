# Copyright 2021 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

CROS_RUST_REMOVE_DEV_DEPS=1

inherit cros-rust

DESCRIPTION='Logs panic messages over RTT using rtt-target'
HOMEPAGE='https://crates.io/crates/panic-rtt-target'
SRC_URI="https://crates.io/api/v1/crates/${PN}/${PV}/download -> ${P}.crate"

LICENSE="MIT"
SLOT="${PV}/${PR}"
KEYWORDS="*"

DEPEND="
	>=dev-rust/cortex-m-0.7.1 <dev-rust/cortex-m-0.8.0_alpha:=
	>=dev-rust/rtt-target-0.3.1 <dev-rust/rtt-target-0.4.0_alpha:=
"
RDEPEND="${DEPEND}"

# This file was automatically generated by cargo2ebuild.py
