# Copyright 2021 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

CROS_RUST_REMOVE_DEV_DEPS=1

inherit cros-rust

DESCRIPTION='A Rust port of Google"s SwissTable hash map'
HOMEPAGE='https://crates.io/crates/hashbrown'
SRC_URI="https://crates.io/api/v1/crates/${PN}/${PV}/download -> ${P}.crate"

LICENSE="|| ( Apache-2.0 MIT )"
SLOT="${PV}/${PR}"
KEYWORDS="*"

DEPEND="
	=dev-rust/ahash-0.7*:=
	=dev-rust/rustc-std-workspace-alloc-1*:=
	>=dev-rust/bumpalo-3.5.0:= <dev-rust/bumpalo-4.0.0
	>=dev-rust/compiler_builtins-0.1.2:= <dev-rust/compiler_builtins-0.2.0
	=dev-rust/rustc-std-workspace-core-1*:=
	=dev-rust/rayon-1*:=
	>=dev-rust/serde-1.0.25:= <dev-rust/serde-2.0.0
"
RDEPEND="${DEPEND}"

# This file was automatically generated by cargo2ebuild.py
