# Copyright 2019 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"


# Migrated crate. See b/240953811 for more about this migration.
DESCRIPTION="Replaced by third-party-crates-src."

LICENSE="metapackage"
SLOT="${PV}/${PR}"
KEYWORDS="*"

DEPEND="dev-rust/third-party-crates-src:="
RDEPEND="${DEPEND}"

# thread 'debug::test::long_and_detailed' panicked at 'assertion failed: `(left == right)`
#  left: `"Style {\n    foreground: Some(\n        Blue\n    ),\n    background: None,\n    blink: false,\n    bold: true,\n    dimmed: false,\n    hidden: false,\n    italic: false,\n    reverse: false,\n    strikethrough: false,\n    underline: false\n}"`,
#  right: `"Style {\n    foreground: Some(\n        Blue,\n    ),\n    background: None,\n    blink: false,\n    bold: true,\n    dimmed: false,\n    hidden: false,\n    italic: false,\n    reverse: false,\n    strikethrough: false,\n    underline: false,\n}"`', src/debug.rs:120:9
RESTRICT="test"
