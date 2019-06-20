# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit cros-rust

DESCRIPTION="OpenSSL bindings for the Rust programming language."
HOMEPAGE="https://github.com/sfackler/rust-openssl/tree/master/openssl-sys"
SRC_URI="https://crates.io/api/v1/crates/${PN}/${PV}/download -> ${P}.crate"

LICENSE="MIT"
SLOT="${PV}/${PR}"
KEYWORDS="*"

DEPEND="
	>=dev-rust/autocfg-0.1.2:=
	=dev-rust/cc-1*:=
	=dev-rust/libc-0.2*:=
	>=dev-rust/pkg-config-0.3.9:=
	=dev-rust/vcpkg-0.2*:=
	>=dev-rust/openssl-src-111.0.1:=
"
