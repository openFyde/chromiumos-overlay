# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit cros-rust

DESCRIPTION="Internal implementation details for ::num_enum (Procedural macros to make inter-operation between primitives and enums easier)"
HOMEPAGE="https://github.com/illicitonion/num_enum"
SRC_URI="https://crates.io/api/v1/crates/${PN}/${PV}/download -> ${P}.crate"

LICENSE="BSD"
SLOT="${PV}/${PR}"
KEYWORDS="*"

DEPEND="
	>=dev-rust/proc-macro-crate-0.1.4:= <dev-rust/proc-macro-crate-0.2
	=dev-rust/proc-macro2-1*:=
	=dev-rust/quote-1*:=
	=dev-rust/syn-1*:=
"
