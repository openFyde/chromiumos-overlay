# Copyright 2021 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

CROS_RUST_REMOVE_DEV_DEPS=1

inherit cros-rust

DESCRIPTION='A highly efficient logging framework that targets resource-constrained devices, like microcontrollers'
HOMEPAGE='https://crates.io/crates/defmt'
SRC_URI="https://crates.io/api/v1/crates/${PN}/${PV}/download -> ${P}.crate"

LICENSE="|| ( MIT Apache-2.0 )"
SLOT="${PV}/${PR}"
KEYWORDS="*"

DEPEND="
	>=dev-rust/defmt-macros-0.2.2 <dev-rust/defmt-macros-0.3.0
	=dev-rust/semver-1*
"
RDEPEND="${DEPEND}"

# This file was automatically generated by cargo2ebuild.py

RESTRICT="test"
