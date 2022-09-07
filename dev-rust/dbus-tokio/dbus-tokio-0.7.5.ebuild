# Copyright 2022 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

CROS_RUST_REMOVE_DEV_DEPS=1

inherit cros-rust

DESCRIPTION='Makes it possible to use Tokio with D-Bus, which is a bus commonly used on Linux for inter-process communication.'
HOMEPAGE='https://crates.io/crates/dbus-tokio'
SRC_URI="https://crates.io/api/v1/crates/${PN}/${PV}/download -> ${P}.crate"

LICENSE="|| ( Apache-2.0 MIT )"
SLOT="${PV}/${PR}"
KEYWORDS="*"

DEPEND="
	=dev-rust/dbus-0.9*
	=dev-rust/dbus-crossroads-0.5*
	>=dev-rust/libc-0.2.69 <dev-rust/libc-0.3.0_alpha
	=dev-rust/tokio-1*
"
RDEPEND="${DEPEND}"

# This file was automatically generated by cargo2ebuild.py
