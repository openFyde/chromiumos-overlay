# Copyright 2021 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

CROS_RUST_REMOVE_DEV_DEPS=1

inherit cros-rust

DESCRIPTION='PNG decoding and encoding library in pure Rust'
HOMEPAGE='https://crates.io/crates/png'
SRC_URI="https://crates.io/api/v1/crates/${PN}/${PV}/download -> ${P}.crate"

PATCHES=(
	"${FILESDIR}/png-0.16.8-update-to-miniz_oxide-0.4.1.patch"
)

LICENSE="|| ( MIT Apache-2.0 )"
SLOT="${PV}/${PR}"
KEYWORDS="*"

DEPEND="dev-rust/third-party-crates-src:="
RDEPEND="${DEPEND}"

RESTRICT="test"
