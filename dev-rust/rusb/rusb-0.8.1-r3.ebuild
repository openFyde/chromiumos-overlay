# Copyright 2021 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"


# Migrated crate. See b/240953811 for more about this migration.
DESCRIPTION="Replaced by third-party-crates-src."

LICENSE="metapackage"
SLOT="${PV}/${PR}"
KEYWORDS="*"

DEPEND="dev-rust/third-party-crates-src:="
RDEPEND="${DEPEND}"


# Tests fail with:
#   munmap_chunk(): invalid pointer
# Very likely a memory safety bug! https://github.com/a1ien/rusb/issues/118
RESTRICT="test"
