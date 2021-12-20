# Copyright 2021 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

CROS_RUST_REMOVE_DEV_DEPS=1

inherit cros-rust

DESCRIPTION='Derive-based argument parsing optimized for code size'
HOMEPAGE='https://crates.io/crates/argh_shared'
SRC_URI="https://crates.io/api/v1/crates/${PN}/${PV}/download -> ${P}.crate"

LICENSE="BSD"
SLOT="${PV}/${PR}"
KEYWORDS="*"


# This file was automatically generated by cargo2ebuild.py
