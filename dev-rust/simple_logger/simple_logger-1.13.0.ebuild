# Copyright 2022 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

CROS_RUST_REMOVE_DEV_DEPS=1
CROS_RUST_REMOVE_TARGET_CFG=1

inherit cros-rust

DESCRIPTION='A logger that prints all messages with a readable output format'
HOMEPAGE='https://crates.io/crates/simple_logger'
SRC_URI="https://crates.io/api/v1/crates/${PN}/${PV}/download -> ${P}.crate"

LICENSE="MIT"
SLOT="${PV}/${PR}"
KEYWORDS="*"

DEPEND="
	>=dev-rust/chrono-0.4.6 <dev-rust/chrono-0.5.0_alpha:=
	=dev-rust/colored-2*:=
	>=dev-rust/log-0.4.5 <dev-rust/log-0.5.0_alpha:=
"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/simple_logger-1.13.0-use-colored-2.patch"
)
