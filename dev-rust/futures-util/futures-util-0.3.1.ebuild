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
"
