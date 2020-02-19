# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit cros-rust

DESCRIPTION="Common utilities and extension traits for the futures-rs library."
HOMEPAGE="https://github.com/rust-lang-nursery/futures-rs"
SRC_URI="https://crates.io/api/v1/crates/${PN}/${PV}/download -> ${P}.crate"

LICENSE="|| ( MIT Apache-2.0 )"
SLOT="${PV}/${PR}"
KEYWORDS="*"

DEPEND="
	>=dev-rust/futures-core-0.3.1:= <dev-rust/futures-core-0.4
	>=dev-rust/futures-task-0.3.1:= <dev-rust/futures-task-0.4
	>=dev-rust/pin-utils-0.1.0_alpha4:= <dev-rust/pin-utils-0.2
	>=dev-rust/proc-macro-nested-0.1.2:= <dev-rust/proc-macro-nested-0.2
	>=dev-rust/futures-0.1.25:= <dev-rust/futures-0.2
	>=dev-rust/futures-channel-0.3.1:= <dev-rust/futures-channel-0.4
	>=dev-rust/futures-io-0.3.1:= <dev-rust/futures-io-0.4
	>=dev-rust/futures-macro-0.3.1:= <dev-rust/futures-macro-0.4
	>=dev-rust/futures-sink-0.3.1:= <dev-rust/futures-sink-0.4
	>=dev-rust/memchr-2.2:= <dev-rust/memchr-3.0
	>=dev-rust/proc-macro-hack-0.5.9:= <dev-rust/proc-macro-hack-0.6
	>=dev-rust/slab-0.4:= <dev-rust/slab-1.0
	>=dev-rust/tokio-io-0.1.9:= <dev-rust/tokio-io-0.2
"
