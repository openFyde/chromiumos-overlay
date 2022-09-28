# Copyright 2020 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

CROS_RUST_REMOVE_DEV_DEPS=1

inherit cros-rust

DESCRIPTION="This crate provides epoch-based garbage collection for building concurrent data structures"
HOMEPAGE="https://github.com/crossbeam-rs/crossbeam/tree/master/crossbeam-epoch"
SRC_URI="https://crates.io/api/v1/crates/${PN}/${PV}/download -> ${P}.crate"

LICENSE="|| ( MIT Apache-2.0 )"
SLOT="${PV}/${PR}"
KEYWORDS="*"

DEPEND="
	dev-rust/third-party-crates-src:=
	=dev-rust/cfg-if-0.1*
	=dev-rust/const_fn-0.4*
	=dev-rust/crossbeam-utils-0.8*
	=dev-rust/lazy_static-1*
"

# error: could not compile `crossbeam-epoch`
RESTRICT="test"
