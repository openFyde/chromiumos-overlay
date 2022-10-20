# Copyright 2019 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

CROS_RUST_CRATE_NAME="rand_core"
# Migrated crate. See b/240953811 for more about this migration.
DESCRIPTION="Replaced by third-party-crates-src."

LICENSE="metapackage"
SLOT="${PV}/${PR}"
KEYWORDS="*"

S="${WORKDIR}/${CROS_RUST_CRATE_NAME}-${PV}"

DEPEND="
	dev-rust/third-party-crates-src:=
	
"
RDEPEND="${DEPEND}"
