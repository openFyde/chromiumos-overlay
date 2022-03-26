# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

CROS_RUST_EMPTY_CRATE=1

inherit cros-rust

DESCRIPTION="Empty ${PN} crate"
HOMEPAGE="https://github.com/rust-cli/paw"

LICENSE="metapackage"
SLOT="${PV}/${PR}"
KEYWORDS="*"
