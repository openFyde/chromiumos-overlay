# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

CROS_RUST_CRATE_VERSION="0.1.0-alpha.4"
S="${WORKDIR}/pin-utils-${CROS_RUST_CRATE_VERSION}"
inherit cros-rust


DESCRIPTION="Utilities for pinning"
HOMEPAGE="https://github.com/rust-lang-nursery/pin-utils"
SRC_URI="https://crates.io/api/v1/crates/${PN}/pin-utils-${CROS_RUST_CRATE_VERSION}/download -> pin-utils-${CROS_RUST_CRATE_VERSION}.crate"

LICENSE="|| ( MIT Apache-2.0 )"
SLOT="${PV}/${PR}"
KEYWORDS="*"
