# Copyright 2021 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

CROS_RUST_REMOVE_DEV_DEPS=1
CROS_RUST_REMOVE_TARGET_CFG=1

inherit cros-rust

DESCRIPTION='Bindings to D-Bus, which is a bus commonly used on Linux for inter-process communication.'
HOMEPAGE='https://crates.io/crates/dbus'
SRC_URI="https://crates.io/api/v1/crates/${PN}/${PV}/download -> ${P}.crate"

LICENSE="|| ( Apache-2.0 MIT )"
SLOT="${PV}/${PR}"
KEYWORDS="*"

DEPEND="
	=dev-rust/futures-channel-0.3*
	=dev-rust/futures-executor-0.3*
	=dev-rust/futures-util-0.3*
	>=dev-rust/libc-0.2.66 <dev-rust/libc-0.3.0_alpha
	=dev-rust/libdbus-sys-0.2*
"
RDEPEND="${DEPEND}"

# This file was automatically generated by cargo2ebuild.py
