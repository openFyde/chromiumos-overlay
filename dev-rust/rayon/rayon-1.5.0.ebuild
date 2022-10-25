# Copyright 2020 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"


# Migrated crate. See b/240953811 for more about this migration.
DESCRIPTION="Replaced by third-party-crates-src."

LICENSE="metapackage"
SLOT="${PV}/${PR}"
KEYWORDS="*"
IUSE="cros_host"

DEPEND="dev-rust/third-party-crates-src:="

# Ensure that rayon deps are installed by default in SDK
# to avoid re-installs at chroot creation time.
RDEPEND="cros_host? ( ${DEPEND} )"

# could not compile
RESTRICT="test"
