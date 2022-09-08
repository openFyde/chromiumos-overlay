# Copyright 2021 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

CROS_RUST_REMOVE_DEV_DEPS=1

inherit cros-rust

DESCRIPTION="This library is an implementation of zero-cost futures in Rust"
HOMEPAGE="https://github.com/rust-lang-nursery/futures-rs"
SRC_URI="https://crates.io/api/v1/crates/${PN}/${PV}/download -> ${P}.crate"

LICENSE="|| ( MIT Apache-2.0 )"
SLOT="${PV}/${PR}"
KEYWORDS="*"

DEPEND="
	>=dev-rust/futures-channel-0.3.13 <dev-rust/futures-channel-0.4
	>=dev-rust/futures-core-0.3.13 <dev-rust/futures-core-0.4
	>=dev-rust/futures-executor-0.3.13 <dev-rust/futures-executor-0.4
	>=dev-rust/futures-io-0.3.13 <dev-rust/futures-io-0.4
	>=dev-rust/futures-sink-0.3.13 <dev-rust/futures-sink-0.4
	>=dev-rust/futures-task-0.3.13 <dev-rust/futures-task-0.4
	>=dev-rust/futures-util-0.3.13 <dev-rust/futures-util-0.4
"
RDEPEND="${DEPEND}
	!~dev-rust/${PN}-0.3.1
"

# error: could not compile `futures`
RESTRICT="test"
