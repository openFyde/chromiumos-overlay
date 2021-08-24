# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit cros-rust

DESCRIPTION="A HashMap wrapper that holds key-value pairs in insertion order"
HOMEPAGE="https://github.com/contain-rs/linked-hash-map"
SRC_URI="https://crates.io/api/v1/crates/${PN}/${PV}/download -> ${P}.crate"

LICENSE="|| ( MIT Apache-2.0 )"
SLOT="${PV}/${PR}"
KEYWORDS="*"

DEPEND="
	=dev-rust/clippy-0.0*:=
	=dev-rust/heapsize-0.4*:=
	=dev-rust/serde-1*:=
	=dev-rust/serde_test-1*:=
"
