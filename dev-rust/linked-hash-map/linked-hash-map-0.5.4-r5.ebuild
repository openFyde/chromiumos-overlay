# Copyright 2019 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

# Migrated crate. See b/240953811 for more about this migration.
DESCRIPTION="Replaced by third-party-crates-src."

LICENSE="metapackage"
SLOT="${PV}/${PR}"
KEYWORDS="*"

DEPEND="dev-rust/third-party-crates-src:="

# thread 'test_consuming_iter_empty' panicked at 'attempted to leave type `std::collections::HashMap<linked_hash_map::KeyRef<&str>, *mut linked_hash_map::Node<&str, i32>>` uninitialized, which is invalid', /var/tmp/portage/dev-lang/rust-1.51.0/work/rustc-1.51.0-src/library/core/src/mem/mod.rs:671:9
RESTRICT="test"
RDEPEND="${DEPEND}"
