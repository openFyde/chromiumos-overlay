# Copyright 2021 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

CROS_RUST_REMOVE_DEV_DEPS=1

inherit cros-rust

DESCRIPTION='Rust wrapper for libudev'
HOMEPAGE='https://github.com/dcuddeback/libudev-rs'
SRC_URI="https://crates.io/api/v1/crates/${PN}/${PV}/download -> ${P}.crate"

LICENSE="MIT"
SLOT="${PV}/${PR}"
KEYWORDS="*"

DEPEND="
	=dev-rust/libc-0.2*
	>=dev-rust/libudev-sys-0.1.3 <dev-rust/libudev-sys-0.2.0_alpha
"
RDEPEND="${DEPEND}"

# This file was automatically generated by cargo2ebuild.py
