# Copyright 2022 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

CROS_RUST_REMOVE_DEV_DEPS=1

inherit cros-rust

DESCRIPTION='Raw FFI bindings to platform libraries like libc.'
HOMEPAGE='https://github.com/rust-lang/libc'
SRC_URI="https://crates.io/api/v1/crates/${PN}/${PV}/download -> ${P}.crate"

LICENSE="|| ( MIT Apache-2.0 )"
SLOT="${PV}/${PR}"
KEYWORDS="*"

DEPEND="
	=dev-rust/rustc-std-workspace-core-1*
"
RDEPEND="${DEPEND}"

# This file was automatically generated by cargo2ebuild.py
