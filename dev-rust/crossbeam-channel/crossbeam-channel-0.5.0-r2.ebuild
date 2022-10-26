# Copyright 2020 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

CROS_RUST_REMOVE_DEV_DEPS=1

inherit cros-rust

DESCRIPTION="This crate provides multi-producer multi-consumer channels for message passing. "
HOMEPAGE="https://github.com/crossbeam-rs/crossbeam/tree/master/crossbeam-channel"
SRC_URI="https://crates.io/api/v1/crates/${PN}/${PV}/download -> ${P}.crate"

LICENSE="|| ( MIT Apache-2.0 )"
SLOT="${PV}/${PR}"
KEYWORDS="*"

DEPEND="
	dev-rust/third-party-crates-src:=
	>=dev-rust/crossbeam-utils-0.8.0 <dev-rust/crossbeam-utils-0.9.0
"

# missing dev deps (signal-hook)
RESTRICT="test"
