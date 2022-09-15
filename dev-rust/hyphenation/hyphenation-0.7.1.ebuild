# Copyright 2019 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

CROS_RUST_EMPTY_CRATE=1
CROS_RUST_EMPTY_CRATE_FEATURES=(embed_all)

inherit cros-rust

DESCRIPTION="Empty hyphenation crate"
HOMEPAGE=""

LICENSE="metapackage"
SLOT="${PV}/${PR}"
KEYWORDS="*"
