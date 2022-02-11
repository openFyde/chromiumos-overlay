# Copyright 2022 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

CROS_RUST_REMOVE_DEV_DEPS=1
CROS_RUST_REMOVE_TARGET_CFG=1

inherit cros-rust

DESCRIPTION='A terminal and console abstraction for Rust'
HOMEPAGE='https://github.com/mitsuhiko/console'
SRC_URI="https://crates.io/api/v1/crates/${PN}/${PV}/download -> ${P}.crate"

LICENSE="MIT"
SLOT="${PV}/${PR}"
KEYWORDS="*"

DEPEND="
	=dev-rust/libc-0.2*:=
	=dev-rust/once_cell-1*:=
	>=dev-rust/regex-1.4.2 <dev-rust/regex-2.0.0_alpha:=
	>=dev-rust/terminal_size-0.1.14 <dev-rust/terminal_size-0.2.0_alpha:=
	=dev-rust/unicode-width-0.1*:=
"
RDEPEND="${DEPEND}"

src_prepare() {
	cros-rust_src_prepare

	# Also delete the 'windows-console-colors' feature, because it refers to
	# deps which were deleted by CROS_RUST_REMOVE_TARGET_CFG=1.
	sed -i -e '/windows-console-colors =/d' Cargo.toml || die
}
