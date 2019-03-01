# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit cros-rust

DESCRIPTION="A library for managing temporary files and directories"
HOMEPAGE="https://github.com/rust-lang/tempfile"
SRC_URI="https://crates.io/api/v1/crates/${PN}/${PV}/download -> ${P}.crate"

LICENSE="|| ( MIT Apache-2.0 )"
SLOT="${PV}/${PR}"
KEYWORDS="*"

DEPEND="
	=dev-rust/cfg-if-0.1*:=
	>=dev-rust/libc-0.2.27:=
	=dev-rust/rand-0.6*:=
	=dev-rust/redox_syscall-0.1*:=
	=dev-rust/remove_dir_all-0.5*:=
	=dev-rust/winapi-0.3*:=
"
