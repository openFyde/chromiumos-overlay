# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

CROS_RUST_REMOVE_DEV_DEPS=1

inherit cros-rust

DESCRIPTION="A general purpose library of common HTTP types"
HOMEPAGE="https://github.com/hyperium/http"
SRC_URI="https://crates.io/api/v1/crates/${PN}/${PV}/download -> ${P}.crate"

LICENSE="|| ( MIT Apache-2.0 )"
SLOT="${PV}/${PR}"
KEYWORDS="*"

DEPEND="
	=dev-rust/bytes-0.4*:=
	>=dev-rust/fnv-1.0.5 <dev-rust/fnv-2.0.0_alpha:=
	>=dev-rust/itoa-0.4.1 <dev-rust/itoa-0.5.0_alpha:=
"
