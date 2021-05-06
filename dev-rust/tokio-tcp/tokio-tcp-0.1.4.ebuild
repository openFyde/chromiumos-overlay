# Copyright 2021 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

CROS_RUST_REMOVE_DEV_DEPS=1

inherit cros-rust

DESCRIPTION="TCP bindings for tokio."
HOMEPAGE="https://tokio.rs"
SRC_URI="https://crates.io/api/v1/crates/${PN}/${PV}/download -> ${P}.crate"

LICENSE="MIT"
SLOT="${PV}/${PR}"
KEYWORDS="*"

DEPEND="
	=dev-rust/bytes-0.4*:=
	>=dev-rust/futures-0.1.19:= <dev-rust/futures-0.2.0
	=dev-rust/iovec-0.1*:=
	>=dev-rust/mio-0.6.14:= <dev-rust/mio-0.7.0
	>=dev-rust/tokio-io-0.1.6:= <dev-rust/tokio-io-0.2.0
	>=dev-rust/tokio-reactor-0.1.1:= <dev-rust/tokio-reactor-0.2.0
"
RDEPEND="${DEPEND}"

# This file was automatically generated by cargo2ebuild.py
