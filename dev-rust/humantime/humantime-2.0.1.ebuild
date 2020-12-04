# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit cros-rust

CROS_RUST_REMOVE_DEV_DEPS=1

DESCRIPTION="Human-friendly time parser and formatter."
HOMEPAGE="https://github.com/tailhook/humantime"
SRC_URI="https://crates.io/api/v1/crates/${PN}/${PV}/download -> ${P}.crate"

LICENSE="|| ( MIT Apache-2.0 )"
SLOT="${PV}/${PR}"
KEYWORDS="*"
