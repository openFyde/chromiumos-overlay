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

# Suppress QA warnings for prebuilt .a files in the crate sources
# shellcheck disable=SC2154 # CROS_RUST_REGISTRY_BASE is defined in cros-rust.eclass
QA_EXECSTACK="${CROS_RUST_REGISTRY_BASE#/}/*"
