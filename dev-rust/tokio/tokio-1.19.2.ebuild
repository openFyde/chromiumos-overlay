# Copyright 2022 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

CROS_RUST_REMOVE_DEV_DEPS=1
CROS_RUST_REMOVE_TARGET_CFG=1

inherit cros-rust

DESCRIPTION='An event-driven, non-blocking I/O platform for writing asynchronous I/O
backed applications.'
HOMEPAGE='https://tokio.rs'
SRC_URI="https://crates.io/api/v1/crates/${PN}/${PV}/download -> ${P}.crate"

LICENSE="MIT"
SLOT="${PV}/${PR}"
KEYWORDS="*"

DEPEND="
	=dev-rust/bytes-1*:=
	>=dev-rust/memchr-2.2.0 <dev-rust/memchr-3.0.0_alpha:=
	>=dev-rust/mio-0.8.1 <dev-rust/mio-0.9.0_alpha:=
	>=dev-rust/num_cpus-1.8.0 <dev-rust/num_cpus-2.0.0_alpha:=
	>=dev-rust/once_cell-1.5.2 <dev-rust/once_cell-2.0.0_alpha:=
	=dev-rust/parking_lot-0.12*:=
	=dev-rust/pin-project-lite-0.2*:=
	>=dev-rust/socket2-0.4.4 <dev-rust/socket2-0.5.0_alpha:=
	>=dev-rust/tokio-macros-1.7.0 <dev-rust/tokio-macros-2.0.0_alpha:=
	>=dev-rust/libc-0.2.42 <dev-rust/libc-0.3.0_alpha:=
	>=dev-rust/signal-hook-registry-1.1.1 <dev-rust/signal-hook-registry-2.0.0_alpha:=
"
RDEPEND="${DEPEND}"

# This file was automatically generated by cargo2ebuild.py

# Changes below are manual:

src_prepare() {
    cros-rust_src_prepare

    # Delete winapi feature dependencies from the Cargo.toml
    mv "${S}/Cargo.toml" "${S}/Cargo.toml.orig" || die
    grep -v '"winapi/' "${S}/Cargo.toml.orig" > "${S}/Cargo.toml" || die
}