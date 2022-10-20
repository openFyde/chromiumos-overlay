# Copyright 2019 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

# Migrated crate. See b/240953811 for more about this migration.
DESCRIPTION="Replaced by third-party-crates-src."

LICENSE="metapackage"
SLOT="${PV}/${PR}"
KEYWORDS="*"

# thread 'tests::probe_as_ref' panicked at 'called `Result::unwrap()` on an `Err` value: Error { kind: Io(Os { code: 2, kind: NotFound, message: "No such file or directory" }) }', src/tests.rs:35:42
RESTRICT="test"
DEPEND="dev-rust/third-party-crates-src:="
RDEPEND="${DEPEND}"
