# Copyright 2021 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

CROS_RUST_REMOVE_DEV_DEPS=1

inherit cros-rust

DESCRIPTION="OpenSSL bindings for the Rust programming language."
HOMEPAGE="https://github.com/sfackler/rust-openssl"
SRC_URI="https://crates.io/api/v1/crates/${PN}/${PV}/download -> ${P}.crate"

LICENSE="Apache-2.0"
SLOT="${PV}/${PR}"
KEYWORDS="*"

DEPEND="
	dev-rust/third-party-crates-src:=
	>=dev-rust/once_cell-1.5.2 <dev-rust/once_cell-2.0.0
	>=dev-rust/openssl-sys-0.9.73 <dev-rust/openssl-sys-0.10.0
"
# (crbug.com/1182669): build-time only deps need to be in RDEPEND so they are
# pulled in when installing binpkgs since the full source tree is required to
# use the crate.
RDEPEND="${DEPEND}
	!=dev-rust/openssl-0.10*
"
