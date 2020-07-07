# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

CROS_RUST_REMOVE_DEV_DEPS=1

inherit cros-rust

DESCRIPTION="Low level HTTP server library"
HOMEPAGE="https://docs.rs/crate/tiny_http/"
SRC_URI="https://crates.io/api/v1/crates/${PN}/${PV}/download -> ${P}.crate"

LICENSE="|| ( MIT Apache-2.0 )"
SLOT="${PV}/${PR}"
KEYWORDS="*"

DEPEND="
	=dev-rust/ascii-1*:=
	=dev-rust/chunked_transfer-1*:=
	=dev-rust/url-2*:=
	=dev-rust/chrono-0.4*:=
	=dev-rust/log-0.4*:=
"

PATCHES=(
	"${FILESDIR}/${P}-0001-unix-socket-support.patch"
	"${FILESDIR}/${P}-0002-remove-ssl-dependency.patch"
)
