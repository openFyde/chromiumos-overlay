# Copyright 2021 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit cros-rust

DESCRIPTION="A Rust library for random number generation."
HOMEPAGE="https://github.com/rust-random/rand"
SRC_URI="https://crates.io/api/v1/crates/${PN}/${PV}/download -> ${P}.crate"

LICENSE="|| ( MIT Apache-2.0 )"
SLOT="${PV}/${PR}"
KEYWORDS="*"

DEPEND="
	=dev-rust/autocfg-0.1*:=
	>=dev-rust/average-0.9.2:=
	=dev-rust/libc-0.2*:=
	=dev-rust/log-0.4*:=
	~dev-rust/rand_chacha-0.1.1:=
	~dev-rust/rand_core-0.4.0:=
	~dev-rust/rand_hc-0.1.0:=
	~dev-rust/rand_isaac-0.1.1:=
	~dev-rust/rand_jitter-0.1.3:=
	~dev-rust/rand_pcg-0.1.2:=
	~dev-rust/rand_xorshift-0.1.1:=
	~dev-rust/rand_xoshiro-0.1.0:=
	=dev-rust/rand_os-0.1*:=
	=dev-rust/winapi-0.3*:=
"
RDEPEND="${DEPEND}"

src_prepare() {
	cros-rust_src_prepare

	# Delete the optional packed_simd dependency. This starts a deps chain
	# down to bindgen and beyond.
	sed -i '/\[dependencies.packed_simd\]/{N;N;N;d;}' "${S}/Cargo.toml"
	sed -i '/simd_support/d' "${S}/Cargo.toml"
}
