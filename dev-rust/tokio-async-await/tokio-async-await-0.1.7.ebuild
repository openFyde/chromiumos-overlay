# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit cros-rust

DESCRIPTION="Experimental async/await support for Tokio"
HOMEPAGE="https://tokio.rs/"
SRC_URI="https://crates.io/api/v1/crates/${PN}/${PV}/download -> ${P}.crate"

LICENSE="MIT"
SLOT="${PV}/${PR}"
KEYWORDS="*"

DEPEND="
	=dev-rust/futures-0.1*:=
	=dev-rust/tokio-io-0.1*:=
	=dev-rust/bytes-0.4*:=
	=dev-rust/hyper-0.12*:=
"
PATCHES=(
	"${FILESDIR}/${P}-0001-Remove-dev-dependencies.patch"
)
