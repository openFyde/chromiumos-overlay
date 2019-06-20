# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit cros-rust

DESCRIPTION="This crate provides multi-producer multi-consumer channels for message passing. "
HOMEPAGE="https://github.com/crossbeam-rs/crossbeam/tree/master/crossbeam-channel"
SRC_URI="https://crates.io/api/v1/crates/${PN}/${PV}/download -> ${P}.crate"

LICENSE="|| ( MIT Apache-2.0 )"
SLOT="${PV}/${PR}"
KEYWORDS="*"

DEPEND="
	=dev-rust/cc-1*:=
	=dev-rust/libc-0.2*:=
	=dev-rust/pkg-config-0.3*:=
	=dev-rust/vcpkg-0.2*:=
"
