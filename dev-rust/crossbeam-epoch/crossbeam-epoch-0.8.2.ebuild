# Copyright 2021 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

CROS_RUST_REMOVE_DEV_DEPS=1

inherit cros-rust

DESCRIPTION="Epoch-based garbage collection"
HOMEPAGE="https://github.com/crossbeam-rs/crossbeam/tree/master/crossbeam-epoch"
SRC_URI="https://crates.io/api/v1/crates/${PN}/${PV}/download -> ${P}.crate"

LICENSE="|| ( MIT Apache-2.0 )"
SLOT="${PV}/${PR}"
KEYWORDS="*"

DEPEND="
	>=dev-rust/cfg-if-0.1.2:= <dev-rust/cfg-if-0.2.0
	=dev-rust/crossbeam-utils-0.7*:=
	=dev-rust/lazy_static-1*:=
	=dev-rust/maybe-uninit-2*:=
	=dev-rust/memoffset-0.5*:=
	=dev-rust/scopeguard-1*:=
	=dev-rust/autocfg-1*:=
"
RDEPEND="${DEPEND}"

# This file was automatically generated by cargo2ebuild.py
