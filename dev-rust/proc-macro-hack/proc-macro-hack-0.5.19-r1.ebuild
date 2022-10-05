# Copyright 2021 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"


# Migrated crate. See b/240953811 for more about this migration.
DESCRIPTION="Replaced by third-party-crates-src."

LICENSE="metapackage"
SLOT="${PV}/${PR}"
KEYWORDS="*"

RDEPEND="!~dev-rust/${PN}-0.5.11"

# error: could not compile `proc-macro-hack`
RESTRICT="test"
DEPEND="dev-rust/third-party-crates-src:="
