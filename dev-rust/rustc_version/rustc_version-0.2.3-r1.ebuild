# Copyright 2019 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

# Migrated crate. See b/240953811 for more about this migration.
DESCRIPTION="Replaced by third-party-crates-src."

LICENSE="metapackage"
SLOT="${PV}/${PR}"
KEYWORDS="*"

DEPEND="dev-rust/third-party-crates-src:="
RDEPEND="${DEPEND}"

# thread 'smoketest' panicked at 'called `Result::unwrap()` on an `Err` value: CouldNotExecuteCommand(Os { code: 2, kind: NotFound, message: "No such file or directory" })', src/lib.rs:202:23
RESTRICT="test"
