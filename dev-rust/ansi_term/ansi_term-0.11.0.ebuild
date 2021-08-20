# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

CROS_RUST_REMOVE_DEV_DEPS=1

inherit cros-rust

DESCRIPTION="Library for ANSI terminal colours and styles (bold, underline)."
HOMEPAGE="https://github.com/ogham/rust-ansi-term"
SRC_URI="https://crates.io/api/v1/crates/${PN}/${PV}/download -> ${P}.crate"

LICENSE="MIT"
SLOT="${PV}/${PR}"
KEYWORDS="*"

DEPEND="
	>=dev-rust/winapi-0.3.4:= <dev-rust/winapi-0.4.0
"
RDEPEND="${DEPEND}"
