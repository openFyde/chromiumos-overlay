# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

CROS_RUST_REMOVE_DEV_DEPS=1

inherit cros-rust

DESCRIPTION="A safer binding to platform's dynamic library loading utilities"
HOMEPAGE="https://github.com/nagisa/rust_libloading/"
SRC_URI="https://crates.io/api/v1/crates/${PN}/${PV}/download -> ${P}.crate"

LICENSE="ISC"
SLOT="${PV}/${PR}"
KEYWORDS="*"

DEPEND="
	=dev-rust/cfg-if-1*:=
	=dev-rust/winapi-0.3*:=
"
