# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit cros-rust

DESCRIPTION="Send log messages to syslog."
HOMEPAGE="https://github.com/Geal/rust-syslog"
SRC_URI="https://crates.io/api/v1/crates/${PN}/${PV}/download -> ${P}.crate"

LICENSE="|| ( MIT Apache-2.0 )"
SLOT="${PV}/${PR}"
KEYWORDS="*"

DEPEND="=dev-rust/error-chain-0.11*
	=dev-rust/libc-0.2*
	=dev-rust/log-0.4*
	=dev-rust/time-0.1*
	=dev-rust/unix_socket-0.5*
"
RDEPEND="${DEPEND}"
