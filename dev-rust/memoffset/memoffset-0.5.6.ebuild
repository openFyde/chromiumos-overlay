# Copyright 2020 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

CROS_RUST_REMOVE_DEV_DEPS=1
inherit cros-rust

DESCRIPTION="C-Like offset_of functionality for Rust structs"
HOMEPAGE="https://github.com/Gilnaa/memoffset"
SRC_URI="https://crates.io/api/v1/crates/${PN}/${PV}/download -> ${P}.crate"

LICENSE="MIT"
SLOT="${PV}/${PR}"
KEYWORDS="*"

DEPEND="=dev-rust/autocfg-1*"
RDEPEND="${DEPEND}"
