# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

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

src_prepare() {
	cros-rust_src_prepare

	# Delete the serde dev dependency. Allowing the dependency introduces a
	# circular dependency, but serde has a legitimate dependency on
	# serde_derive.
	sed -i '/\[dev-dependencies.serde\]/{N;d;}' "${S}/Cargo.toml"
}
