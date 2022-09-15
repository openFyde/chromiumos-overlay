# Copyright 2019 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit cros-rust

DESCRIPTION="A cryptographically secure random number generator that uses the ChaCha algorithm"
HOMEPAGE="https://github.com/rust-random/rand"
SRC_URI="https://crates.io/api/v1/crates/${PN}/${PV}/download -> ${P}.crate"

LICENSE="|| ( MIT Apache-2.0 )"
SLOT="${PV}/${PR}"
KEYWORDS="*"

DEPEND="
	=dev-rust/autocfg-0.1*
	<dev-rust/rand_core_transitional-0.4.0
"
