# Copyright 2019 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit cros-rust

DESCRIPTION="Semantic version parsing and comparison"
HOMEPAGE="https://docs.rs/crate/semver/"
SRC_URI="https://crates.io/api/v1/crates/${PN}/${PV}/download -> ${P}.crate"

LICENSE="|| ( MIT Apache-2.0 )"
SLOT="${PV}/${PR}"
KEYWORDS="*"

DEPEND="
	dev-rust/third-party-crates-src:=
	=dev-rust/serde-1*
	=dev-rust/crates-index-0.5*
	=dev-rust/serde_derive-1*
	=dev-rust/serde_json-1*
	=dev-rust/tempdir-0.3*
"

# error: could not compile `semver`
RESTRICT="test"
