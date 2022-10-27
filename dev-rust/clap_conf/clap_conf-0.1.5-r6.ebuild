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

# and then manually modified:

# ---- tests::try_holder stdout ----
# thread 'tests::try_holder' panicked at 'assertion failed: `(left == right)`
#   left: `Some("/var/tmp/portage/dev-rust/clap_conf-0.1.5/work/clap_conf-0.1.5")`,
#  right: `Some("/home/matthew/scripts/rust/mlibs/clap_conf")`', src/lib.rs:137:9
RESTRICT="test"
