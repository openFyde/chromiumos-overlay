# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit cros-rust

DESCRIPTION="Mio is a lightweight I/O library for Rust with a focus on adding as little overhead as possible over the OS abstractions"
HOMEPAGE="https://github.com/carllerche/mio"
SRC_URI="https://crates.io/api/v1/crates/${PN}/${PV}/download -> ${P}.crate"

LICENSE="MIT"
SLOT="${PV}/${PR}"
KEYWORDS="*"

DEPEND="
	=dev-rust/fuchsia-zircon-0.3*:=
	=dev-rust/fuchsia-zircon-sys-0.3*:=
	=dev-rust/iovec-0.1*:=
	=dev-rust/kernel32-sys-0.2*:=
	=dev-rust/libc-0.2*:=
	=dev-rust/log-0.4*:=
	=dev-rust/miow-0.2*:=
	=dev-rust/net2-0.2*:=
	=dev-rust/slab-0.4*:=
	=dev-rust/winapi-0.2*:=
	=dev-rust/bytes-0.3*:=
	=dev-rust/env_logger-0.4*:=
	=dev-rust/tempdir-0.3*:=
"
