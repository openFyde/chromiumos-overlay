# Copyright 2019 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit cros-rust

DESCRIPTION="Provide as direct as possible access to the system's functionality for sockets as possible"
HOMEPAGE="https://github.com/alexcrichton/socket2-rs"
SRC_URI="https://crates.io/api/v1/crates/${PN}/${PV}/download -> ${P}.crate"

LICENSE="|| ( MIT Apache-2.0 )"
SLOT="${PV}/${PR}"
KEYWORDS="*"

DEPEND="
	dev-rust/third-party-crates-src:=
	=dev-rust/cfg-if-0.1*
	=dev-rust/redox_syscall-0.1*
	=dev-rust/tempdir-0.3*
"
