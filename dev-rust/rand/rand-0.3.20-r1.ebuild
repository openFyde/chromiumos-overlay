# Copyright 2022 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

DESCRIPTION="Empty crate"
HOMEPAGE=""

LICENSE="metapackage"
SLOT="${PV}"
KEYWORDS="*"

# Migrated crate. See b/240953811 for more about this migration.
DEPEND="dev-rust/third-party-crates-src:="
RDEPEND="${DEPEND}"
