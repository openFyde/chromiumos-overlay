# Copyright 2018 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

# Migrated crate. See b/240953811 for more about this migration.
DESCRIPTION="Replaced by third-party-crates-src."

LICENSE="metapackage"
SLOT="${PV}/${PR}"
KEYWORDS="*"

DEPEND="dev-rust/third-party-crates-src:="

# ---- test_debug_tokenstream stdout ----
# thread 'test_debug_tokenstream' panicked at 'assertion failed: `(left == right)`
#  left: `"TokenStream [\n    Group {\n        delimiter: Bracket,\n        stream: TokenStream [\n            Ident {\n                sym: a\n            },\n            Punct {\n                op: \'+\',\n                spacing: Alone\n            },\n            Literal {\n                lit: 1\n            }\n        ]\n    }\n]"`,
# right: `"TokenStream [\n    Group {\n        delimiter: Bracket,\n        stream: TokenStream [\n            Ident {\n                sym: a,\n            },\n            Punct {\n                op: \'+\',\n                spacing: Alone,\n            },\n            Literal {\n                lit: 1,\n            },\n        ],\n    },\n]"`', tests/test.rs:382:5
RESTRICT="test"
RDEPEND="${DEPEND}"
