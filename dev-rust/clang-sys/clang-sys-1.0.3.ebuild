# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

CROS_RUST_REMOVE_DEV_DEPS=1

inherit cros-rust

DESCRIPTION="Rust bindings for libclang."
HOMEPAGE="https://github.com/KyleMayes/clang-sys"
SRC_URI="https://crates.io/api/v1/crates/${PN}/${PV}/download -> ${P}.crate"

LICENSE="Apache-2.0"
SLOT="${PV}/${PR}"
KEYWORDS="*"

DEPEND="
	=dev-rust/glob-0.3*:=
	>=dev-rust/libc-0.2.39:= <dev-rust/libc-0.3.0
	=dev-rust/libloading-0.6*:=
"
