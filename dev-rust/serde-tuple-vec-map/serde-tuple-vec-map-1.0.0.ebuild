# Copyright 2022 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

CROS_RUST_REMOVE_DEV_DEPS=1

inherit cros-rust

DESCRIPTION='Deserialize a serialized map to a Vec<(K, V)> in serde'
HOMEPAGE='https://crates.io/crates/serde-tuple-vec-map'
SRC_URI="https://crates.io/api/v1/crates/${PN}/${PV}/download -> ${P}.crate"

LICENSE="MIT"
SLOT="${PV}/${PR}"
KEYWORDS="*"

DEPEND="
	=dev-rust/serde-1*
"
RDEPEND="${DEPEND}"

# This file was automatically generated by cargo2ebuild.py
