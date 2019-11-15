# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

CROS_RUST_REMOVE_DEV_DEPS=1

inherit cros-rust

DESCRIPTION="OpenSSL bindings for the Rust programming language."
HOMEPAGE="https://github.com/sfackler/rust-openssl"
SRC_URI="https://crates.io/api/v1/crates/${PN}/${PV}/download -> ${P}.crate"

LICENSE="Apache-2.0"
SLOT="${PV}/${PR}"
KEYWORDS="*"

DEPEND="
	>=dev-rust/bitflags-1.0:=
	>=dev-rust/cfg-if-0.1:=
	>=dev-rust/foreign-types-0.3.1:=
	>=dev-rust/lazy_static-1.0:=
	>=dev-rust/libc-0.2:=
	>=dev-rust/openssl-sys-0.9.50:=
"
