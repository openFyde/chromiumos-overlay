# Copyright 2021 The ChromiumOS Authors
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
	dev-rust/third-party-crates-src:=
	=dev-rust/chrono-0.4*
"
RDEPEND="${DEPEND}
	!~dev-rust/tiny_http-0.7.0
"

PATCHES=(
	"${FILESDIR}/${P}-0001-unix-socket-support.patch"
	"${FILESDIR}/${PN}-0.7.0-0002-remove-ssl-dependency.patch"
)
