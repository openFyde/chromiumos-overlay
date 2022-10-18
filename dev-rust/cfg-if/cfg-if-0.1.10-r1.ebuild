# Copyright 2018 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

# Migrated crate. See b/240953811 for more about this migration.
DESCRIPTION="Replaced by third-party-crates-src."

LICENSE="metapackage"
SLOT="${PV}/${PR}"
KEYWORDS="*"

# error: no matching package named `compiler_builtins` found
RESTRICT="test"
DEPEND="dev-rust/third-party-crates-src:="
RDEPEND="${DEPEND}"
