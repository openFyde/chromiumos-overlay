# Copyright 2022 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

CROS_RUST_REMOVE_DEV_DEPS=1

inherit cros-rust

DESCRIPTION='Serial port implementation for Unix.'
HOMEPAGE='https://github.com/dcuddeback/serial-rs'
SRC_URI="https://crates.io/api/v1/crates/${PN}/${PV}/download -> ${P}.crate"

LICENSE="MIT"
SLOT="${PV}/${PR}"
KEYWORDS="*"

DEPEND="
	>=dev-rust/ioctl-rs-0.1.5 <dev-rust/ioctl-rs-0.2.0_alpha
	>=dev-rust/libc-0.2.1 <dev-rust/libc-0.3.0_alpha
	=dev-rust/serial-core-0.4*
	>=dev-rust/termios-0.2.2 <dev-rust/termios-0.3.0_alpha
"
RDEPEND="${DEPEND}"

# This file was automatically generated by cargo2ebuild.py

# During src_test, cargo tries to find ../serial-core instead of grabbing it
# from the registry.
RESTRICT="test"
