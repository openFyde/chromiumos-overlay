# Copyright 2021 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

CROS_RUST_REMOVE_DEV_DEPS=1

inherit cros-rust

DESCRIPTION='Rust Bindings for the Scudo Hardened Allocator'
HOMEPAGE='https://llvm.org/docs/ScudoHardenedAllocator.html'
SRC_URI="https://crates.io/api/v1/crates/${PN}/${PV}/download -> ${P}.crate"

LICENSE="Apache-2.0"
SLOT="${PV}/${PR}"
KEYWORDS="*"

DEPEND="
	>=dev-rust/libc-0.2.104 <dev-rust/libc-0.3.0_alpha
	=dev-rust/scudo-sys-0.2*
"
RDEPEND="${DEPEND}"

# This file was automatically generated by cargo2ebuild.py
