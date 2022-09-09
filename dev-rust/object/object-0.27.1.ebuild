# Copyright 2021 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

CROS_RUST_REMOVE_DEV_DEPS=1

inherit cros-rust

DESCRIPTION='A unified interface for reading and writing object file formats.'
HOMEPAGE='https://crates.io/crates/object'
SRC_URI="https://crates.io/api/v1/crates/${PN}/${PV}/download -> ${P}.crate"

LICENSE="|| ( Apache-2.0 MIT )"
SLOT="${PV}/${PR}"
KEYWORDS="*"

DEPEND="
	=dev-rust/rustc-std-workspace-alloc-1*
	>=dev-rust/compiler_builtins-0.1.2 <dev-rust/compiler_builtins-0.2.0_alpha
	=dev-rust/rustc-std-workspace-core-1*
	>=dev-rust/crc32fast-1.2.0 <dev-rust/crc32fast-2.0.0_alpha
	=dev-rust/flate2-1*
	>=dev-rust/indexmap-1.1.0 <dev-rust/indexmap-2.0.0_alpha
	>=dev-rust/memchr-2.4.1 <dev-rust/memchr-3.0.0_alpha
	=dev-rust/wasmparser-0.57*
"
RDEPEND="${DEPEND}"

# This file was automatically generated by cargo2ebuild.py
