# Copyright 2021 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

CROS_RUST_REMOVE_DEV_DEPS=1

inherit cros-rust

DESCRIPTION="Pre-allocated storage for a uniform data type"
HOMEPAGE="https://github.com/tokio-rs/slab"
SRC_URI="https://crates.io/api/v1/crates/${PN}/${PV}/download -> ${P}.crate"

LICENSE="MIT"
SLOT="${PV}/${PR}"
KEYWORDS="*"

DEPEND="
	>=dev-rust/serde-1.0.95:= <dev-rust/serde-2.0.0
"
RDEPEND="${DEPEND}"

# This file was automatically generated by cargo2ebuild.py
