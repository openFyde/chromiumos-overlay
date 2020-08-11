# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

CROS_RUST_REMOVE_DEV_DEPS=1

inherit cros-rust

DESCRIPTION="Serde is a framework for serializing and deserializing Rust data structures efficiently and generically"
HOMEPAGE="https://github.com/serde-rs/serde"
SRC_URI="https://crates.io/api/v1/crates/${PN}/${PV}/download -> ${P}.crate"

LICENSE="|| ( MIT Apache-2.0 )"
SLOT="${PV}/${PR}"
KEYWORDS="*"

DEPEND="
	=dev-rust/proc-macro2-0.4*:=
	>=dev-rust/quote-0.6.3:= <dev-rust/quote-0.7
	>=dev-rust/syn-0.15.22:= <dev-rust/syn-0.16
"
