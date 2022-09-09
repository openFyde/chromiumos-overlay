# Copyright 2021 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

CROS_RUST_REMOVE_DEV_DEPS=1

inherit cros-rust

DESCRIPTION='A library for reading and writing the DWARF debugging format.'
HOMEPAGE='https://crates.io/crates/gimli'
SRC_URI="https://crates.io/api/v1/crates/${PN}/${PV}/download -> ${P}.crate"

LICENSE="|| ( Apache-2.0 MIT )"
SLOT="${PV}/${PR}"
KEYWORDS="*"

DEPEND="
	=dev-rust/rustc-std-workspace-alloc-1*
	>=dev-rust/compiler_builtins-0.1.2 <dev-rust/compiler_builtins-0.2.0_alpha
	=dev-rust/rustc-std-workspace-core-1*
	=dev-rust/fallible-iterator-0.2*
	>=dev-rust/indexmap-1.0.2 <dev-rust/indexmap-2.0.0_alpha
	>=dev-rust/stable_deref_trait-1.1.0 <dev-rust/stable_deref_trait-2.0.0_alpha
"
RDEPEND="${DEPEND}"

# This file was automatically generated by cargo2ebuild.py
