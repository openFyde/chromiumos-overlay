# Copyright 2022 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

CROS_RUST_REMOVE_DEV_DEPS=1

inherit cros-rust

DESCRIPTION='Framework for writing D-Bus method handlers'
HOMEPAGE='https://crates.io/crates/dbus-crossroads'
SRC_URI="https://crates.io/api/v1/crates/${PN}/${PV}/download -> ${P}.crate"

LICENSE="|| ( Apache-2.0 MIT )"
SLOT="${PV}/${PR}"
KEYWORDS="*"

# dev-rust/dbus needs to be 0.9.3 or newer, but a wildcard constraint is used to
# avoid a 0.6 version being pulled in to the slot.
DEPEND="
	=dev-rust/dbus-0.9*
"
RDEPEND="${DEPEND}"
