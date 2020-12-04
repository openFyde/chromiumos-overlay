# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

CROS_RUST_REMOVE_DEV_DEPS=1

inherit cros-rust

DESCRIPTION="A lightweight logging facade for rust"
HOMEPAGE="https://github.com/rust-lang/log"
SRC_URI="https://crates.io/api/v1/crates/${PN}/${PV}/download -> ${P}.crate"

LICENSE="|| ( MIT Apache-2.0 )"
SLOT="${PV}/${PR}"
KEYWORDS="*"

DEPEND="
	>=dev-rust/cfg-if-0.1.2:= <dev-rust/cfg-if-0.2.0
	=dev-rust/serde-1*:=
	=dev-rust/sval-1*:=
"
