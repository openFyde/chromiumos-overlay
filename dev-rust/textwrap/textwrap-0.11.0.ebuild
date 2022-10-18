# Copyright 2019 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit cros-rust

DESCRIPTION="Word wrapping text"
HOMEPAGE="https://github.com/mgeisler/textwrap"
SRC_URI="https://crates.io/api/v1/crates/${PN}/${PV}/download -> ${P}.crate"

LICENSE="|| ( MIT Apache-2.0 )"
SLOT="${PV}/${PR}"
KEYWORDS="*"

CROS_RUST_REMOVE_DEV_DEPS=1

DEPEND="
	dev-rust/third-party-crates-src:=
	=dev-rust/hyphenation-0.7*
"

# error: could not compile `textwrap`
RESTRICT="test"
