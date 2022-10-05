# Copyright 2021 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"


# Migrated crate. See b/240953811 for more about this migration.
DESCRIPTION="Replaced by third-party-crates-src."

LICENSE="metapackage"
SLOT="${PV}/${PR}"
KEYWORDS="*"

DEPEND="dev-rust/third-party-crates-src:="
# This DEPEND was removed to break a circular dependency.
#   ">=dev-rust/tokio-io-0.1.9 <dev-rust/tokio-io-0.2"
# It is needed if the io-compat feature is set, an empty crate is substituted to
# avoid breaking ebuilds that depend on futures-util but do not set io-compat.
DEPEND+=" ~dev-rust/tokio-io-0.1.9"
RDEPEND="
	${DEPEND}
	!~dev-rust/${PN}-0.3.1
"

# error: no matching package named `futures` found
RESTRICT="test"
