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

DEPEND="dev-rust/third-party-crates-src:="
