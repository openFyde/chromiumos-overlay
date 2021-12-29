# Copyright 2021 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

# We can't set CROS_RUST_REMOVE_TARGET_CFG=1 because it drops the libudev
# dependency entirely, leading to an error from cargo:
#   feature `default` includes `libudev` which is neither a dependency nor
#   another feature
# So we patch out the Windows- and macOS-specific dependencies below instead.

inherit cros-rust

DESCRIPTION='A cross-platform low-level serial port library'
HOMEPAGE='https://crates.io/crates/serialport'
SRC_URI="https://crates.io/api/v1/crates/${PN}/${PV}/download -> ${P}.crate"

PATCHES=(
	"${FILESDIR}/serialport-4.0.1-linux-only.patch"
)

LICENSE="MPL-2.0"
SLOT="${PV}/${PR}"
KEYWORDS="*"

DEPEND="
	=dev-rust/libudev-0.2*:=
	>=dev-rust/bitflags-1.0.4 <dev-rust/bitflags-2.0.0_alpha:=
	=dev-rust/cfg-if-0.1*:=
	>=dev-rust/nix-0.16.1 <dev-rust/nix-0.17.0_alpha:=
	>=dev-rust/clap-2.32.0 <dev-rust/clap-3.0.0_alpha:=
"
RDEPEND="${DEPEND}"
