# Copyright 2020 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit cros-rust

DESCRIPTION="Rust implementation of Google protocol buffers"
HOMEPAGE="https://github.com/stepancheg/rust-protobuf/"
SRC_URI="https://crates.io/api/v1/crates/${PN}/${PV}/download -> ${P}.crate"

LICENSE="MIT"
SLOT="${PV}/${PR}"
KEYWORDS="*"

DEPEND="dev-rust/third-party-crates-src:="

RDEPEND="${DEPEND}"

# error: failed to select a version for the requirement `bytes = "^1.0"`
RESTRICT="test"
