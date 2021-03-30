# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit cros-rust

DESCRIPTION="Procedural macros to make inter-operation between primitives and enums easier."
HOMEPAGE="https://github.com/illicitonion/num_enum"
SRC_URI="https://crates.io/api/v1/crates/${PN}/${PV}/download -> ${P}.crate"

LICENSE="BSD"
SLOT="${PV}/${PR}"
KEYWORDS="*"

DEPEND="
	=dev-rust/derivative-2*:=
	=dev-rust/num_enum_derive-0.5*:=
"
