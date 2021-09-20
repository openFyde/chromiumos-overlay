# Copyright 2021 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

CROS_RUST_REMOVE_DEV_DEPS=1

inherit cros-rust

DESCRIPTION="Core I/O primitives for asynchronous I/O in Rust."
HOMEPAGE="https://tokio.rs"
SRC_URI="https://crates.io/api/v1/crates/${PN}/${PV}/download -> ${P}.crate"

LICENSE="MIT"
SLOT="${PV}/${PR}"
KEYWORDS="*"

DEPEND="
	>=dev-rust/bytes-0.4.7:= <dev-rust/bytes-0.5.0
	>=dev-rust/futures-0.1.18:= <dev-rust/futures-0.2.0
	=dev-rust/log-0.4*:=
"
RDEPEND="${DEPEND}"

# This file was automatically generated by cargo2ebuild.py

# error: could not compile `tokio-io`
RESTRICT="test"
