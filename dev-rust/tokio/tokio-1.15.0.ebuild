# Copyright 2022 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

CROS_RUST_EMPTY_CRATE=1
CROS_RUST_EMPTY_CRATE_FEATURES=( io-std net )

inherit cros-rust

DESCRIPTION="Empty crate"
HOMEPAGE=""

LICENSE="metapackage"
SLOT="${PV}/${PR}"
KEYWORDS="*"
