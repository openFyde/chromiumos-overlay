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


IUSE="test"
TEST_DEPS="
	test? (
		=dev-rust/serde_bytes-0.10*
		=dev-rust/serde_json-1*
	)
"
DEPEND+="${TEST_DEPS}"
RDEPEND+="${TEST_DEPS}"

src_prepare() {
	if use test; then
		CROS_RUST_REMOVE_DEV_DEPS=0
	fi
	cros-rust_src_prepare
}
