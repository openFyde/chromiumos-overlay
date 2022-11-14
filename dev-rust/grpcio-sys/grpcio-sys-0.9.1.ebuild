# Copyright 2022 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"


# Migrated crate. See b/240953811 for more about this migration.
DESCRIPTION="Replaced by third-party-crates-src."

LICENSE="metapackage"
SLOT="${PV}/${PR}"
KEYWORDS="*"

DEPEND="dev-rust/third-party-crates-src:="
RDEPEND="${DEPEND}"

# ${PV} was changed from the original 0.9.1+1.38.0
