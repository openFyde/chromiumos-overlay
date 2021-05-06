# Copyright 2021 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

CROS_RUST_REMOVE_DEV_DEPS=1

inherit cros-rust

DESCRIPTION="'Small vector' optimization: store up to a small number of items on the stack"
HOMEPAGE="https://crates.io/crates/smallvec"
SRC_URI="https://crates.io/api/v1/crates/${PN}/${PV}/download -> ${P}.crate"

LICENSE="|| ( MIT Apache-2.0 )"
SLOT="${PV}/${PR}"
KEYWORDS="*"

DEPEND="
	=dev-rust/maybe-uninit-2*:=
	=dev-rust/serde-1*:=
"
RDEPEND="${DEPEND}"

# This file was automatically generated by cargo2ebuild.py
