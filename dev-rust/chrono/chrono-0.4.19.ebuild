# Copyright 2020 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit cros-rust

DESCRIPTION="Aims to be a feature-complete superset of the time library"
HOMEPAGE="https://github.com/chronotope/chrono"
SRC_URI="https://crates.io/api/v1/crates/${PN}/${PV}/download -> ${P}.crate"

LICENSE="|| ( MIT Apache-2.0 )"
SLOT="${PV}/${PR}"
KEYWORDS="*"

DEPEND="
	dev-rust/third-party-crates-src:=
	=dev-rust/bincode-0.8*
	=dev-rust/serde_json-1*
"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/${PN}-remove-time-dependency.patch"
)

# error: no matching package named `pure-rust-locales` found
RESTRICT="test"
