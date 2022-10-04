# Copyright 2021 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

CROS_RUST_REMOVE_DEV_DEPS=1

inherit cros-rust

DESCRIPTION='A Rust port of Google"s SwissTable hash map'
HOMEPAGE='https://crates.io/crates/hashbrown'
SRC_URI="https://crates.io/api/v1/crates/${PN}/${PV}/download -> ${P}.crate"

LICENSE="|| ( Apache-2.0 MIT )"
SLOT="${PV}/${PR}"
KEYWORDS="*"

DEPEND="
	dev-rust/third-party-crates-src:=
	~dev-rust/ahash-0.7.0
	=dev-rust/rayon-1*
"
RDEPEND="${DEPEND}"

# This file was automatically generated by cargo2ebuild.py

# ahash is pinned to 0.7.0 since newer verison of ahash(0.7.6) results in cyclic dependency.
# the package `hashbrown` depends on `ahash`, with features: `compile-time-rng` but `ahash` does not have these features.
RESTRICT="test"
