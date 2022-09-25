# Copyright 2019 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit cros-rust

DESCRIPTION="Official FlexBuffers Rust runtime library."
HOMEPAGE="https://google.github.io/flatbuffers/flexbuffers"
SRC_URI="https://crates.io/api/v1/crates/${PN}/${PV}/download -> ${P}.crate"

LICENSE="Apache-2.0"
SLOT="${PV}/${PR}"
KEYWORDS="*"

DEPEND="
	dev-rust/third-party-crates-src:=
	=dev-rust/num_enum-0.5*
	>=dev-rust/serde-1.0.114 <dev-rust/serde-2
	=dev-rust/serde_derive-1*
"
RDEPEND="${DEPEND}"
