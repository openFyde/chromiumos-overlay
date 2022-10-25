# Copyright 2021 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"


# Migrated crate. See b/240953811 for more about this migration.
DESCRIPTION="Replaced by third-party-crates-src."

LICENSE="metapackage"
SLOT="${PV}/${PR}"
KEYWORDS="*"

# Note that we don't (yet) depend directly on third-party-crates-src, but
# `third-party-crates-src` _does_ emerge a package which is a semver-compatible
# upgrade of this. In order for transitive dependencies of this package to not
# race with its installation, we need a DEPEND on it here.
DEPEND="dev-rust/third-party-crates-src:="
RDEPEND="${DEPEND}"
