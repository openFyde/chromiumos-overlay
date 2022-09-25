# Copyright 2021 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

CROS_RUST_REMOVE_DEV_DEPS=1

inherit cros-rust

DESCRIPTION="A Rust library for retrieving random data from (operating) system source"
HOMEPAGE="https://github.com/rust-random/getrandom"
SRC_URI="https://crates.io/api/v1/crates/${PN}/${PV}/download -> ${P}.crate"

LICENSE="|| ( MIT Apache-2.0 )"
SLOT="${PV}/${PR}"
KEYWORDS="*"

DEPEND="
	dev-rust/third-party-crates-src:=
	>=dev-rust/cfg-if-0.1.2 <dev-rust/cfg-if-0.2.0
	>=dev-rust/wasi-0.9.0 <dev-rust/wasi-0.10.0
	>=dev-rust/stdweb-0.4.18 <dev-rust/stdweb-0.5.0
"

RDEPEND="${DEPEND}"
