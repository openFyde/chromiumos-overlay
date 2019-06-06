# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit cros-rust

DESCRIPTION="Bindings to the system libz library (also known as zlib)."
HOMEPAGE="https://github.com/rust-lang/libz-sys"
SRC_URI="https://crates.io/api/v1/crates/${PN}/${PV}/download -> ${P}.crate"

LICENSE="|| ( MIT Apache-2.0 )"
SLOT="${PV}/${PR}"
KEYWORDS="*"

DEPEND=">=dev-rust/cc-1.0.18:=
	>=dev-rust/libc-0.2.43:=
	>=dev-rust/pkg-config-0.3.9:=
	>=dev-rust/vcpkg-0.2:=
"
