# Copyright 2020 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit cros-rust

DESCRIPTION="ASCII-only equivalents to 'char', 'str' and 'String'."
HOMEPAGE="https://docs.rs/crate/ascii/"
SRC_URI="https://crates.io/api/v1/crates/${PN}/${PV}/download -> ${P}.crate"

LICENSE="|| ( MIT Apache-2.0 )"
SLOT="${PV}/${PR}"
KEYWORDS="*"

# serde and serde_test are unused optional dependencies, but add them in anyways
# so that we don't get errors from cargo later on.
DEPEND="
	dev-rust/third-party-crates-src:=
	>=dev-rust/serde_test-1 <dev-rust/serde_test-2
"
