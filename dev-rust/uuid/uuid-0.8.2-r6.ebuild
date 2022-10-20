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

# And, we removed `CROS_RUST_REMOVE_TARGET_CFG=1` manually as the dependency
# "winapi" was declared as the form of
# `[target.'cfg(windows)'.dependencies.winapi]`.
