# Copyright 2022 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

CROS_RUST_REMOVE_DEV_DEPS=1

inherit cros-rust

DESCRIPTION='A Rust wrapper over libftdi1 library for FTDI devices'
HOMEPAGE='https://github.com/tanriol/ftdi-rs'
SRC_URI="https://crates.io/api/v1/crates/${PN}/${PV}/download -> ${P}.crate"

LICENSE="MIT"
SLOT="${PV}/${PR}"
KEYWORDS="*"

DEPEND="
	=dev-rust/ftdi-mpsse-0.1*
	>=dev-rust/libftdi1-sys-1.1.0 <dev-rust/libftdi1-sys-2.0.0_alpha
	>=dev-rust/thiserror-1.0.15 <dev-rust/thiserror-2.0.0_alpha
"
RDEPEND="${DEPEND}"

src_prepare() {
	default

	# libftdi1-sys has no 'vendored' feature in ChromiumOS.
	sed -i -e '/^vendored =/d' Cargo.toml

	# This example doesn't compile (missing deps) and is not included in the
	# upstream git tree, it was likely pulled into the crate sources by
	# mistake.
	rm examples/ftdi-listen-serial.rs

	# https://github.com/tanriol/ftdi-rs/pull/22
	cp "${FILESDIR}/LICENSE" "${S}"
}
