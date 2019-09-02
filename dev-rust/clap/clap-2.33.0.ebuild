# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit cros-rust

DESCRIPTION="Command Line Argument Parser"
HOMEPAGE="https://github.com/clap-rs/clap"
SRC_URI="https://crates.io/api/v1/crates/${PN}/${PV}/download -> ${P}.crate"

LICENSE="|| ( MIT Apache-2.0 )"
SLOT="${PV}/${PR}"
KEYWORDS="*"

CROS_RUST_REMOVE_DEV_DEPS=1

DEPEND="
	=dev-rust/bitflags-1*:=
	=dev-rust/textwrap-0.11*:=
	=dev-rust/unicode-width-0.1*:=
	=dev-rust/ansi_term-0.11*:=
	=dev-rust/atty-0.2*:=
	=dev-rust/clippy-0.0.166:=
	=dev-rust/strsim-0.8*:=
	=dev-rust/term_size-0.3*:=
	=dev-rust/vec_map-0.8*:=
	=dev-rust/yaml-rust-0.3.5:=
"
