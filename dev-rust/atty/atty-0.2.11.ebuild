# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit cros-rust

DESCRIPTION="are you or are you not a tty?"
HOMEPAGE="https://github.com/softprops/atty"
SRC_URI="https://crates.io/api/v1/crates/${PN}/${PV}/download -> ${P}.crate"

LICENSE="|| ( MIT )"
SLOT="${PV}/${PR}"
KEYWORDS="*"

DEPEND="
	>=dev-rust/termion-1.5.1:=
	>=dev-rust/libc-0.2.0:=
	>=dev-rust/winapi-0.3.0:=
"
