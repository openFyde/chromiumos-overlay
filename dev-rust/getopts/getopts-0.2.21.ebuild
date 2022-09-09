# Copyright 2021 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

CROS_RUST_REMOVE_DEV_DEPS=1

inherit cros-rust

DESCRIPTION="getopts-like option parsing."
HOMEPAGE="https://github.com/rust-lang/getopts"
SRC_URI="https://crates.io/api/v1/crates/${PN}/${PV}/download -> ${P}.crate"

LICENSE="|| ( MIT Apache-2.0 )"
SLOT="${PV}/${PR}"
KEYWORDS="*"

DEPEND="
	=dev-rust/rustc-std-workspace-core-1*
	=dev-rust/rustc-std-workspace-std-1*
	>=dev-rust/unicode-width-0.1.5 <dev-rust/unicode-width-0.2.0
"
RDEPEND="${DEPEND}"

# This file was automatically generated by cargo2ebuild.py

# error: could not compile `getopts`
RESTRICT="test"
